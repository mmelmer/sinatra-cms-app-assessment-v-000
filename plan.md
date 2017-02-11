classes:
  -user
  -apartment
  -for sale
  -wanted


user:
  -attributes:
    -username; text
    -email; text
    -password; text
  -has many apartments
  -has many for sale
  -has many wanted

apartment:
  -attributes:
    -price; #
    -content; text
    -user_id; #
  -belongs to user

for sale:
  attributes:
   -price; #
    -content; text
    -user_id; #
  -belongs to user

wanted:
  attributes:
    -content; text
    -user_id; #
  -belongs to user