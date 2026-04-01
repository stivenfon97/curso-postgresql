/*=======================================================================*/
/*============== DISENO TABLA INVENTARIO =================*/
/*=======================================================================*/
enum product_status {
  in_stock
  out_of_stock
  running_low
}

enum order_status {
  placed
  confirm
  proceseed
  complete
}

table product {
  id int [pk, increment]
  serial varchar
  name varchar(200)
  merchant int [ref: > merchant.id]
  price float(8,2)
  stock int
  status product_status
  created_at timestamp [default: 'now()']
  updated_at timestamp [default: 'now()']
}

table merchant {
  id int [pk, increment]
  name varchar
  country int [ref: > country.id]
  created_at timestamp [default: 'now()']
}

table country {
  id int [pk, increment]
  name varchar
}

table order {
  id int [pk, increment]
  status order_status
  user_id int
  total float(12,2)
  created_at timestamp [default: 'now()']
}

table order_item {
  id int [pk, increment]
  order_id int [ref: > order.id]
  product_id int [ref: > product.id]
  quantity int
}

/*=======================================================================*/
/*============== DISENO DB TWEETER =================*/
/*=======================================================================*/
table user {
  id int [pk, increment]
  name varchar(100)
  slug varchar(50)
  email varchar [unique]
  bio text

  created_at timestamp [default: 'now()']
}

table tweet {
  id int [pk, increment]
  content varchar(150)
  user_id int [ref: > user.id]

  created_at timestamp [default: 'now()']
}

table follower {
  id int [pk, increment]
  follower_id int
  followed_id int
  created_at timestamp [default: 'now()']
}

Ref: "user"."id" < "follower"."follower_id"

Ref: "user"."id" < "follower"."followed_id"