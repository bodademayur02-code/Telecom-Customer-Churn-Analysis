
------section 1: create base view-----

---create churn_base view joining all three tables
create view churn_base as
select
      c.customer_id,
      c.gender,
      c.age,
      c.senior_citizen,
      c.married,
      c.dependents,
      s.tenure_in_months,
      s.contract,
      s.internet_type,
      s.payment_method,
      s.monthly_charge,
      s.total_revenue,
      t.churn_value,
      t.quarter,
      t.cltv,
      t.churn_category
from customer c
join services s on c.customer_id=s.customer_id
join status t on c.customer_id=t.customer_id;

------section 2: overall churn metrics-----
---q1. what is the overall churn rate?
select
round(sum(churn_value)*100.0/count(*),2) as churn_rate
from status;


---q2. how many customers churned vs retained?
select
      case when churn_value=1 then 'churned' else 'retained' end as churn_status,
      count(*) as customers,
      round(100.0*count(*)/sum(count(*)) over(),2) as pct
from status
group by churn_status;


---q3. what is the churn rate by churn category?
select churn_category,
count(*) as customers,
round(100.0*count(*)/sum(count(*)) over(),2) as pct
from status
where churn_value=1
group by churn_category
order by customers desc;


------section 3: customer demographics & churn-----

---q4. how does gender affect churn rate?
select gender,
round(100.0*sum(churn_value)/count(*),2) as churn_rate
from churn_base
group by gender;


---q5. what is the churn rate for senior citizens vs non-senior?
select senior_citizen,
round(100.0*sum(churn_value)/count(*),2) as churn_rate
from churn_base
group by senior_citizen;


---q6. what is the churn rate by age group?
select
      case when age < 30 then 'under 30'
	  else '30+'
	  end as age_group,
	  round(100.0*sum(churn_value)/count(*),2) as churn_rate
from churn_base
group by age_group;


---q7. how do marital status and dependents affect churn?
select married,dependents,
round(100.0*sum(churn_value)/count(*),2) as churn_rate
from churn_base
group by married,dependents;


------section 4: tenure & contract analysis-----

---q8. what is the churn rate by tenure group?
select
      case
	  when tenure_in_months < 6 then 'new (0-6 months)'
	  when tenure_in_months < 12 then '6-12 months'
	  when tenure_in_months between 12 and 24 then '12-24 months'
	  else '24+ months'
	  end as tenure_group,
	  round(100.0*sum(churn_value)/count(*),2) as churn_rate
from churn_base
group by tenure_group
order by churn_rate desc;


---q9. what is the churn rate by contract type?
select contract,
count(*) as customers,
sum(churn_value) as churned,
round(100.0*sum(churn_value)/count(*),2) as churn_rate
from churn_base
group by contract
order by churn_rate desc;


---q10. how does contract type combined with dependents affect churn?
select contract,dependents,
round(100.0*sum(churn_value)/count(*),2) as churn_rate
from churn_base
group by contract,dependents
order by churn_rate desc;


------section 5: service & internet analysis-----

---q11. what is the churn rate by internet service and internet type?
select s.internet_service,
       c.internet_type,
	   count(*) as customers,
	   round(100.0*sum(c.churn_value)/count(*),2) as churn_rate
from churn_base c
join services s on s.customer_id=c.customer_id
group by s.internet_service,c.internet_type
order by churn_rate desc;


---q12. how do phone service, multiple lines, and unlimited data affect churn?
select
    s.phone_service,
    s.multiple_lines,
    s.unlimited_data,
    round(100.0*sum(c.churn_value)/count(*),2) as churn_rate
from churn_base c
join services s on s.customer_id=c.customer_id
group by s.phone_service,s.multiple_lines,s.unlimited_data
order by churn_rate desc;


---q13. what is the churn rate by extra data charges bucket?
with buckets as (
select s.total_extra_data_charges as data_charge,
       s.internet_type,
       t.churn_value,
       case when s.total_extra_data_charges < 40  then '0-40'
            when s.total_extra_data_charges < 80  then '40-80'
	        when s.total_extra_data_charges < 150 then '80-150'
	        else '150+'
	        end as charge_bucket
from services s join status t on t.customer_id=s.customer_id
)
select charge_bucket,internet_type,
count(*) as customers,
round(100.0*sum(churn_value)/count(*),2) as churn_rate
from buckets
group by charge_bucket,internet_type
order by churn_rate desc;


------section 6: pricing & payment analysis-----

---q14. what is the churn rate by monthly charge tier?
select case
       when monthly_charge < 40 then 'low (< 40)'
	   when monthly_charge < 80 then 'medium (40-80)'
	   else 'high (80+)'
	   end as price_tag,
	   count(*) as customers,
	   round(100.0*sum(churn_value)/count(*),2) as churn_rate
from churn_base
group by price_tag
order by churn_rate desc;


---q15. how does payment method and paperless billing affect churn?
select c.payment_method,s.paperless_billing,
count(*) as customers,
round(100.0*sum(c.churn_value)/count(*),2) as churn_rate
from churn_base c join services s
on c.customer_id=s.customer_id
group by c.payment_method,s.paperless_billing
order by churn_rate desc;


---q16. does having a refund reduce churn rate?
select
    case when s.total_refunds > 0 then 'refunded'
	else 'no refund' end as refund_flag,
    count(*) as customers,
    round(100.0*sum(c.churn_value)/count(*),2) as churn_rate
from churn_base c join services s
on c.customer_id=s.customer_id
group by refund_flag;


------section 7: cltv & revenue analysis-----

---q17. what is the churn rate by cltv segment (quartile)?
select cltv_segment,
       count(*) as customers,
	   sum(churn_value) as churned,
	   round(100.0*sum(churn_value)/count(*),2) as churn_rate
from (
select cltv,
churn_value,
ntile(4) over(order by cltv) as cltv_segment
from status
) t
group by cltv_segment
order by cltv_segment;


---q18. who are the top churned customers causing the highest revenue loss (top 80%)?
with revenue_loss as (
    select
        customer_id,
        cltv,
        sum(cltv) over() as total_loss,
        sum(cltv) over(order by cltv desc) as cumulative_loss
    from churn_base
    where churn_value=1
)
select *
from revenue_loss
where cumulative_loss <= total_loss * 0.8
order by cltv desc;


------section 8: multi-factor churn analysis-----

---q19. what is the churn rate by contract, internet type, and payment method combined?
select
    contract,
    internet_type,
    payment_method,
    count(*) as customers,
    round(100.0*sum(churn_value)/count(*),2) as churn_rate
from churn_base
group by contract,internet_type,payment_method
having count(*) > 50
order by churn_rate desc;


---q20. what is the churn risk profile by tenure, charge, and contract?
select
      case
	  when tenure_in_months < 12 and monthly_charge > 80 and contract='month-to-month' then 'very high risk'
	  when tenure_in_months < 24 and monthly_charge > 60 then 'high risk'
	  when tenure_in_months >= 24 and contract != 'month-to-month' then 'low risk'
	  else 'medium risk'
	  end as churn_risk,
	  count(*) as customers,
	  round(100.0*sum(churn_value)/count(*),2) as churn_rate
from churn_base
group by churn_risk
order by churn_rate desc;


---q21. what is the avg monthly charge, cltv, and tenure for churned vs retained customers?
select
      case when churn_value=1 then 'churned' else 'retained' end as churn_status,
      round(avg(monthly_charge),2) as avg_monthly_charge,
      round(avg(cltv),2) as avg_cltv,
      round(avg(tenure_in_months),2) as avg_tenure
from churn_base
group by churn_status;


------end of file-----