/*
Посчитать количество матчей, в которых first_blood_time больше
1 минуты, но меньше 3х минут;
*/

SELECT COUNT(*) FROM match WHERE first_blood_time between 60 and 180;