/* oldest users of the application */
select id,username
from users
order by created_at
limit 5;

/* Inactive users - who haven't posted single photo since registering */
SELECT user_id,users.username
FROM (
  SELECT user_id, COUNT(DISTINCT photo_id) AS count_photoids
  FROM likes
  GROUP BY user_id
) AS nt
join users on nt.user_id=users.id
WHERE count_photoids = (SELECT COUNT(DISTINCT photo_id) FROM likes);

/* photos with the most likes */
select photos.id,photos.image_url,photos.user_id, 
count(likes.user_id) as count_likes,likes.photo_id,users.username 
from photos join likes on likes.photo_id=photos.id
join users on photos.user_id=users.id 
group by photo_id 
order by count_likes desc limit 1;

/* Registration count of users weekday-wise */
select dayname(created_at) as days_of_week,count(dayname(created_at)) as user_registration_count
from users 
group by days_of_week
order by user_registration_count desc;

/* Popular Hashtags */
select tags.tag_name,count(photo_tags.tag_id) as count_hashtages_used
from tags 
join photo_tags on tags.id=photo_tags.tag_id  
group by tags.tag_name 
order by count_hashtages_used desc limit 5;

/* Avg time of times a users posts a picure */
select sum(post_per_user)/count(total_users)  as avg_post from
(select u.id as total_users,count(p.id) as post_per_user from users u
left join photos p
on u.id=p.user_id
group by u.id
having count(p.id)>0) a

/* Fake Accounts or Bots */
select user_id,users.username
FROM (
  SELECT user_id, COUNT(DISTINCT photo_id) AS count_photoids
  FROM likes
  GROUP BY user_id
) AS nt
join users on nt.user_id=users.id
WHERE count_photoids = (SELECT COUNT(DISTINCT photo_id) FROM likes)
order by user_id;
