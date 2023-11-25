# Ticket Types
- [ ] Add fees to order form
- [ ] Add fees to order summary

# Shows Index
- [ ] Finish

# Shows#show
- [ ] Add general information
- [ ] Add upsales

- [ ] Add upsales to shopping cart
- [ ] Add upsales to order form
- [ ] Add customer questions to order form

# Next steps:
- [ ] Omniauth?
- [ ] Refunds
- [ ] System tests for placing an order
- [ ] System tests for trying to reserve a seat reserved by another user
- [ ] System tests for trying to reserve a seat sold another user
- [ ] Remove show_id from order_tickets and go through show_seats
- [ ] Dropdown to show who you're logged in as, view your orders, edit your profile, and sign out
- [ ] Stay logged in? button
- [ ] Edit user screen
- [ ] Convenience fees, deposits, billing
- [ ] Test stripe webhook refunds payments
- [ ] Stimulus controller to remove required message when the field is focused

# Seating Charts
- [ ] Have destroy method just deactivate a seating chart if it has shows
- [ ] Convert slide over component to use el-transition

## Sections
- [ ] Autofocus section when a new section is rendered

# Users
- [ ] Add password requirements
- [ ] Add sign out button and system test for signing out
- [ ] Don't let logged in users go to login page
- [ ] Add profile editing
- [ ] Add stay logged in cookie
- [ ] Password reset

# Checkout
- [ ] Test invalid credit card info
- [ ] ? broadcast an alert letting users know that items in their shopping cart have expired when they're on the new order page and items expire
- [ ] Copy credit card SVGs from stripe payment element to use in application

# Guest Conversion
- [ ] Send "welcome, set your password" email

# Shopping Cart
- [ ] Clicking on a show link in the shopping cart doesn't work
- [ ] See if there's a way to use peer-empty to display a "nothing in your cart" message

# Merch
- [ ] Add ordering of merch

# Bugs
- [ ] Adding "required" field to errored fields makes the fields look weird when they have the "$" and "USD" stuff in them. (see new show form, submit a section with no pricing)
- [ ] Update merch, add category but don't fill anything in then save. Should pass validation but doesn't
- [ ] You can uncheck the "All" chip
- [ ] Cancelling a seat reservation from the shopping cart doesn't remove the seat from the shopping cart, but it does update the count and the circle color
- [ ] Order form not validating address properly
- [ ] Deleting an existing seat on an existing seating chart does nothing
- [ ] Ticket types form - convenience fee error messages are not styled properly
- [ ] Shopping cart is weird
- [ ] Removing a section on the seating chart form closes the slideout

- Outstanding merch orders screen
- Shipped button on Merch