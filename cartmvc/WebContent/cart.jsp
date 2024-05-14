<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="mvc.products" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart</title>
   <style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
 background-color:pink;
    background-image:url("https://static.vecteezy.com/system/resources/previews/006/663/095/non_2x/shopping-concept-cartons-or-paper-boxes-and-shopping-bag-in-red-shopping-cart-on-pink-background-online-shopping-consumers-can-shop-from-home-and-delivery-service-with-copy-space-free-photo.jpg");
     
    height: 100vh;
    }
	  .header {
            height: 80px;
            width: 100%;
            background-color: #343a40;
         
            color: white;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 15px;
            box-sizing: border-box;
        }
		h1{
		text-align:center;
		margin-right:550px;
		}
        .header .logo {
            height:70px;
            width :70px;
            border-radius:50px;
        }
    .container {
        max-width: 800px;
        margin: 0 auto;
        padding: 20px;
    }

    .cart-item {
        border: 1px solid #ddd;
        border-radius: 8px;
        padding: 10px;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        background-color:white;
    }

    .cart-item img {
        width: 100px;
        height: auto;
        margin-right: 20px;
    }

    .cart-item-details {
        flex: 1;
    }

    .cart-item-details h3 {
        margin: 0;
        font-size: 18px;
        color: #333;
    }

    .cart-item-details p {
        margin: 5px 0;
        color: #777;
    }

    .remove-button,
    .checkout-button {
        background-color: green;
        border: none;
        color: white;
        padding: 8px 16px;
        text-align: center;
        text-decoration: none;
        display: inline-block;
        font-size: 14px;
        cursor: pointer;
        border-radius: 4px;
        transition: background-color 0.3s;
    }

    .remove-button:hover,
    .checkout-button:hover {
        background-color: #2980b9;
    }

    @media only screen and (max-width: 600px) {
        .cart-item img {
            width: 80px;
            margin-right: 10px;
        }

        .cart-item-details h3 {
            font-size: 16px;
        }

        .cart-item-details p {
            font-size: 12px;
        }

        .remove-button,
        .checkout-button {
            padding: 6px 12px;
            font-size: 12px;
        }
    }
</style>
<script src="https://checkout.razorpay.com/v1/checkout.js"></script>

</head>
<body>
<div class="header">
        <img src="shoplogo.jpg" class="logo">
        <center><h1>Online Shopping</h1></center>
        
    </div>
	<br><br>
    <div class="container">
        <h2>Shopping Cart</h2>
        <% 
        List<mvc.products> cartItems = (List<mvc.products>) request.getSession().getAttribute("cart");
        if (cartItems != null) {
            double totalProductPrice = 0.0;
            for (mvc.products item : cartItems) {
                totalProductPrice += item.getprice();
        %>
        <div class="cart-item">
            <div class="cart-item-details">
            <img src=<%=item.getimage() %>>
                <h3><%= item.getname() %></h3>
                <p>Price: $<%= item.getprice() %></p>
                <button class="remove-button" onclick="removeItem('<%= item.getpid() %>')">Remove</button>
            </div>
        </div>
        <% 
            }
            
            double gstOnProducts = totalProductPrice * 0.18; // Assuming GST rate is 18%
            double shippingCharges = totalProductPrice * 0.05; // Assuming shipping charges are 5% of total product price
            double gstOnShippingCharges = shippingCharges * 0.18; // Assuming GST rate is 18%
            double totalBill = totalProductPrice + gstOnProducts + shippingCharges + gstOnShippingCharges;
        %>
        <div style="background-color:white;height:200px;margin-top:2px;border-radius:1px">
            <p>Total Product Price: $<%= totalProductPrice %></p>
            <p>GST on Products: $<%= gstOnProducts %></p>
            <p>Shipping Charges: $<%= shippingCharges %></p>
            <p>GST on Shipping Charges: $<%= gstOnShippingCharges %></p>
            <h3 id="totalBill" style="display: none;" ><%= totalBill %></h3>
            <h3>Total Bill: <%=totalBill %></h3>

        </div>
        <% } %>
   <table style="border-collapse:collapse;margin-top:50px;" border="1">
        <thead>
            <tr>
				<th>discount</th>
				<th>product actual price</th>
				<th>product actual gst</th>
				<th>price</th>
				<th>Shipping charge on product</th>
                <th>Shipping charge with GST</th>
            </tr>
        </thead>
        <tbody>
    <%
        for (ProductPriceDetails ppd : lpd) {
        	shippingAmount=ppd.getShippingamount();
        	t=ppd.getTotalprice();
			session.setAttribute("totalcp",t);
       %>
    <tr>
    	<td><div style="text-align:center;"><%= ppd.getDiscount()%></div></td>
    	<td><div style="text-align:center;"><%= ppd.getProductactualprice()%></div></td>
    	<td><div style="text-align:center;"><%= ppd.getProductactualgst()%></div></td>
    	<td><div style="text-align:center;"><%= ppd.getPrice()%></div></td>
        <td><div style="text-align:center;"><%= ppd.getShippingchargeshare() %></div></td>
        <td><div style="text-align:center;"><%= ppd.getShippingchargewithgst() %></div></td>
    </tr>
    <%
    }
    %>
</tbody>
 
    </table>
        <a href="final.jsp" class="checkout-button">Check Out</a>
        <a id="rzp-button1" href="#" class="checkout-button" onclick="placeOrder()">Place Order</a>

        
        <a href="ProductServlet" class="checkout-button" onclick="checkout()">Continue shopping</a>
    </div>
    <script>

    function placeOrder() {
        var pincode = prompt("Please enter your pincode:");
        if (pincode) {
            var cartItems = document.querySelectorAll('.cart-item');
            var validPincode = true;

            cartItems.forEach(item => {
                var productId = item.dataset.productid;
                fetch('CheckPincodeServlet?pincode=' + pincode + '&productId=' + productId)
                .then(response => response.json())
                .then(data => {
                    if (!data.valid) {
                        validPincode = false;
                    }
                })
                .catch(error => {
                    console.error('Error checking pincode:', error);
                    validPincode = false;
                });
            });

            if (validPincode) {
            	 var rzpButton = document.getElementById('rzp-button1');
                 
                 if (rzpButton) {
                     var options = {
                         // Razorpay options here
                         "key": "rzp_test_GD8S8aHD7CFQUE", // Enter the Key ID generated from the Dashboard
                         "amount": getTotalBill(), // Call function to get totalBill dynamically
                         "currency": "INR",
                         "description": "Online Shopping",
                         "image": "https://s3.amazonaws.com/rzp-mobile/images/rzp.jpg",
                         "prefill":
                         {
                             "email": "gaurav.kumar@example.com",
                             "contact": +919900000000,
                         },
                         config: {
                             display: {
                                 blocks: {
                                     utib: { //name for Axis block
                                         name: "Pay using Axis Bank",
                                         instruments: [
                                             {
                                                 method: "card",
                                                 issuers: ["UTIB"]
                                             },
                                             {
                                                 method: "netbanking",
                                                 banks: ["UTIB"]
                                             },
                                         ]
                                     },
                                     other: { //  name for other block
                                         name: "Other Payment modes",
                                         instruments: [
                                             {
                                                 method: "card",
                                                 issuers: ["ICIC"]
                                             },
                                             {
                                                 method: 'netbanking',
                                             }
                                         ]
                                     }
                                 },
                                 hide: [
                                     {
                                         method: "upi"
                                     }
                                 ],
                                 sequence: ["block.utib", "block.other"],
                                 preferences: {
                                     show_default_blocks: false // Should Checkout show its default blocks?
                                 }
                             }
                         },
                         "handler": function (response) {
                             alert(response.razorpay_payment_id);
                         },
                         "modal": {
                             "ondismiss": function () {
                                 if (confirm("Are you sure, you want to close the form?")) {
                                     txt = "You pressed OK!";
                                     console.log("Checkout form closed by the user");
                                 } else {
                                     txt = "You pressed Cancel!";
                                     console.log("Complete the Payment")
                                 }
                             }
                         }
                     };
                     var rzp1 = new Razorpay(options);
                     rzpButton.onclick = function (e) {
                         rzp1.open();
                         e.preventDefault();
                     };
                 } else {
                     console.error('Element with ID "rzp-button1" not found');
                 }
                // Remaining code for Razorpay integration...
            } else {
                alert('The pincode you entered is not serviceable for some products in your cart.');
            }
        }
    }


    function getTotalBill() {
        var totalBillElement = document.getElementById('totalBill');
        if (totalBillElement) {
            return parseFloat(totalBillElement.innerText.replace('$', ''))*100;
        }
        return 0;
    }

 

        function checkout() {
            // Check if the user is logged in (you can use a session attribute to store login status)
            window.location.href = "login.html"; 
            
        }

        function removeItem(productId) {
            fetch('AddToCartServlet?productId=' + productId, {
                method: 'DELETE'
            })
            .then(response => {
                if (response.ok) {
                    window.location.reload();
                } else {
                    console.error('Failed to remove item from cart');
                }
            })
            .catch(error => {
                console.error('Error removing item from cart:', error);
            });
        }
    </script>
</body>
</html>
