SELECT Person.Name, FollowsPerson.Name AS FollowedPerson
FROM  Network.Person, Network.Follows,
	  Network.Person AS FollowsPerson
WHERE MATCH(Person-(Follows)->FollowsPerson)
 AND Person.Name = 'Lou Iss';