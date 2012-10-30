![Crowdtilt](http://f9b43d4100c64ffefa80-01a69cdaa3d52fbca65973574eec9d29.r21.cf2.rackcdn.com/ct_logo.png)

# Crowdtilt API Specs

The Crowdtilt API opens up the opportunity for developers to:
* Offer a group payments option in their applications.
* Offer a pre-sales commerce option in their applications.
* Develop a crowdfunding application (i.e., single project model like Lockitron
    or multi-project model like Kickstarter).
* Develop a social fundraising application.
* Enable the collaboration around these styles of commerce.

What we think is cool about the Crowdtilt API:
* Developers can use the Crowdtilt API with their own payment processor
    as it works with [Stripe](https://stripe.com/),
    [Balanced](https://www.balancedpayments.com/),
    [WePay](https://www.wepay.com/),
    [BrainTree](https://www.braintreepayments.com).
* The API also works with credit cards and ACH debit payments or a combination
    of these.
* The API provides collaboration tools such as commenting/updates, nested
    comments, messaging, notifications, and tracking of those that have paid and
    those that haven't.
* The API supports both multiple currencies and international languages.

# Menu
* [Introduction](#introduction)
* [Getting Started](#getting-started)
* [User Resources](#user-resources)
    * [Users](#users)
    * [User Campaigns](#user-campaigns)
    * [User Cards](#user-cards)
    * [User Banks](#user-banks)
    * [User Payments](#user-payments)
* [Campaign Resources](#campaign-resources)
    * [Campaigns](#campaigns)
    * [Campaign Payments](#campaign-payments)
    * [Refunds](#refunds)
    * [Campaign Settlements](#campaign-settlements)
    * [Campaign Comments](#campaign-comments)
* [Examples](#examples)
* [Pagination](#pagination)


## Introduction

It is important to understand that the Crowdtilt API is a layer of abstraction
on top payment processors. When interacting with a payment gateway, the focus
is highly transactional and payment-based.
We consider a payment to be simply a part of a whole.
Our API helps you focus on the whole.

The API defines 3 main objects: ``campaign``, ``user``, and ``payment``. At a
very high-level, a ``campaign`` represents a monetary goal that one or more
``users`` try to achieve through ``payments``. The campaign can define multiple
payment policies such as ``fixed payments``, e.g, tickets, or ``variable
payments``, e.g., donations.

``Payments`` are simply a way for users to achieve the campaign goal. We believe
that a good crowdfunding service should support any type of payment. Therefore,
we are working on supporting as many payment methods as possible. Currently, we
support credit cards and ACH debits.

When the campaign is created, it has to have at least one ``user`` to act as the
owner or the campaign admin. Once the campaign goal is achieved, the money is
sent to the campaign admin according to the policies defined when the campaign
was created.

Here is a full definition for each one of those objects:
[campaign](#campaign-definition), [user](#user-definition),
[payment](#payment-definition).


## Getting Started

The first step is to get an ``API_KEY`` and ``API_SECRET``. During our beta
program, please contact
[support.api@crowdtilt.com](mailto:support.api@crowdtilt.com?Subject=API%20Creds)
to request these.  Once you receive your Crowdtilt API credentials, you are
ready to use the API.  Remember that all API requests have to go over SSL.


### Sandbox Environment

To help you build your application, we provide a sandbox environment that you
can use for testing. Use the base URI below:

    https://api-sandbox.crowdtilt.com/v1/

The sandbox environment will be configured with a free Balanced account. If
you need support for a different payment processor, please
[let us know](mailto:support.api@crowdtilt.com?Subject=API%20Payment%20Processor%20Sandbox).


### Authentication

We are big fans of simplicity. Therefore, we support ``Basic Authentication``
over SSL. You can simply use ``curl`` to test our API in 2 seconds.

    $ curl -u API_KEY:API_SECRET https://api.crowdtilt.com/v1

If the credentials provided were invalid, the API will respond with

    401 => Unauthorized


### Data Formats

Currently, we only support JSON data formats. If you think we should support
other data formats, please let us know what and why
[support.api@crowdtilt.com](mailto:support.api@crowdtilt.com?Subject=Data%20Formats).


### Client Libraries

Unfortunately, we don't have client libraries, yet. If you write one, let us
know and we'll link to it.


### Hackers Support

We like hanging out on IRC, a lot. Feel free to come hang out with us #crowdtilt
at freenode. You can also send an email to
[support.api@crowdtilt.com](mailto:support.api@crowdtilt.com).


### Getting involved

We need your help and we would love to get you involved. Feel free to create
github issues, give feedback and comment on ones, submit pull requests, or
review specs. You can even ask for new features and vote on the ones you like to
be a higher priority.


### When is feature X going to be in production?

Any proposed spec change will be in a separate "feature" branch. Once we have a
consensus from the community on the spec change, it'll be merged into `dev`
branch, which means that the <a href="https://www.crowdtilt.com"
target="_blank">Crowdtilt</a> team will start working on it. Once it is fully
implemented and ready to go to production, it'll get merged to the `master`
branch.


## User Resources

* [Users](#users)
* [User Campaigns](#user-campaigns)
* [User Cards](#user-cards)
* [User Banks](#user-banks)
* [User Payments](#user-payments)

<table>
    <thead>
        <tr>
            <th>Path</th>
            <th>HTTP Methods</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>/users</td>
            <td>
                <a href="#list-users">GET</a>
                <a href="#create-user">POST</a> </td>
            <td> List of users </td>
        </tr>
        <tr>
            <td>/users/authentication</td>
            <td>
                <a href="#authenticate-user">GET</a>
            </td>
            <td> Authenticate a user</td>
        </tr>
        <tr>
            <td>/users/:id</td>
            <td>
                <a href="#get-user">GET</a>
                <a href="#update-user">PUT</a>
            </td>
            <td> A specific user </td>
        </tr>
        <tr>
            <td>/users/:id/verification</td>
            <td>
                <a href="#verify-user">POST</a>
            </td>
            <td> Verify a user to receive payments </td>
        </tr>
        <tr>
            <td>/users/:id/campaigns</td>
            <td>
                <a href="#get-user-campaigns">GET</a>
            </td>
            <td> All campaigns the user is involved with </td>
        </tr>
        <tr>
            <td>/users/:id/paid_campaigns</td>
            <td>
                <a href="#get-user-paid-campaigns">GET</a>
            </td>
            <td> Campaigns this user paid for </td>
        </tr>
        <tr>
            <td>/users/:id/cards</td>
            <td>
                <a href="#list-user-cards">GET</a>
                <a href="#create-user-card">POST</a>
            </td>
            <td>User credit cards</td>
        </tr>
        <tr>
            <td>/users/:id/cards/:id</td>
            <td>
                <a href="#get-user-card">GET</a>
                <a href="#update-user-card">PUT</a>
                <a href="#delete-user-card">DELETE</a>
            </td>
            <td>A specific credit card</td>
        </tr>
        <tr>
            <td>/users/:id/banks</td>
            <td>
                <a href="#list-user-banks">GET</a>
                <a href="#create-user-bank">POST</a>
            </td>
            <td>User bank accounts</td>
        </tr>
        <tr>
            <td>/users/:id/banks/:id</td>
            <td>
                <a href="#get-user-bank">GET</a>
                <a href="#update-user-bank">PUT</a>
                <a href="#delete-user-bank">DELETE</a>
            </td>
            <td>A specific bank account</td>
        </tr>
        <tr>
            <td>/users/:id/payments</td>
            <td>
                <a href="#list-user-payments">GET</a>
            </td>
            <td> A list of Users payments</td>
        </tr>
    </tbody>
</table>

## Users

### Create User

    POST /users

    $ curl -XPOST -HContent-Type:application/json \
    -u key:secret http://api.crowdtilt.com/v1/users \
    -d'
    {
       "user" : {
          "firstname" : "foo",
          "lastname" : "bar",
          "email" : "user@example.com"
       }
    }'

#### Response Body

    {
        "user": {
            "id": "USREC5",
            "email": "foo.bar@gmail.com",
            "firstname": "Foo",
            "lastname": "Bar",
            "is_verified": 0,
            "img": "http://example.com/profile.png",
            "creation_date": "2011-07-02T14:20:48Z",
            "last_login_date": "2012-09-22T01:55:49Z",
            "uri": "/v1/users/USREC5",
            "campaigns_uri": "/v1/users/USREC5/campaigns",
            "paid_campaigns_uri": "/v1/users/USREC5/paid_campaigns",
            "payments_uri": "/v1/users/USREC5/payments",
            "roles" : ["contributor"],
            "metadata": {}
        }
    }

#### Response Codes

    201 => Created
    400 => Bad Request


### Verify User

In order for a user to receive money raised from a campaign, the user's identity
needs to be verified.  A user is verified by `POST`ing verification data to the
`/users/:id/verification`.

The verification data is as follows:

* `name` - should be the real name of the user
* `dob` - the date of birth of the user in the format MM-YYYY
* `phone_number` - the user's phone number
* `street_address` - the user's street address
* `postal code` - the user's postal code

In some cases, if the user cannot be fully verified with this information, we
may return a `449` response indicating that we need more info.  In these cases
you should re-post the data with the additional `ssn` field containing the
user's social security number for additional verification.

Once the verification has succeeded, `is_verified` on the user object
will be set to 1 to reflect this change.

    POST /users/:id/verification

    $ curl -XPOST -HContent-Type:application/json -u key:secret \
    http://api.crowdtilt.com/v1/users/USREC5 \
    -d'
    {
       "verification" : {
          "name" : "Khaled Hussein",
          "dob" : "07-1984",
          "phone_number" : "(000) 000-0000",
          "street_address" : "324 awesome address, awesome city, CA",
          "postal_code" : "12345"
       }
    }'

#### Response Body

    {}

#### Response Codes

    200 => OK
    400 => Bad Data, or Could not Verify admin information
    449 => Retry with SSN


### Authenticate User

To authenticate a user, you can pass in the user's login credentials, email and
password, as query parameters.

    GET /users/authentication?email=user@example.com&password=mypassword

#### Response Body

    {
       "user" : {
          "id" : "USRB07",
          "firstname" : "foo",
          "lastname" : "bar",
          "status" : 1,
          "img" : null,
          "email" : "user@example.com",
          "verified" : 0,
          "creation_date" : "2012-09-26T10:22:03.900529000Z",
          "last_login_date" : "2012-09-26T17:22:20Z"
       }
    }

#### Response Codes

    302 => Found
    401 => Unauthorized


### Get User

    GET  /users/:id

    $ curl -u key:secret \
    https://api.crowdtilt.com/v1/users/USREC5

#### Response Body

    {
        "user": {
            "id": "USREC5",
            "email": "foo.bar@gmail.com",
            "firstname": "Foo",
            "lastname": "Bar",
            "is_verified": 1,
            "img": "http://example.com/profile.png",
            "creation_date": "2011-07-02T14:20:48Z",
            "last_login_date": "2012-09-22T01:55:49Z",
            "uri": "/v1/users/USREC5",
            "campaigns_uri": "/v1/users/USREC5/campaigns",
            "paid_campaigns_uri": "/v1/users/USREC5/paid_campaigns",
            "payments_uri": "/v1/users/USREC5/payments",
            "roles" : ["contributor"],
            "metadata": {}
        }
    }

#### Response Codes

    200 => OK


### List Users

    GET /users

    $ curl -u key:secret https://api.crowdtilt.com/v1/users

#### Response Body

    {
        "pagination": {
            "total_pages": 1,
            "page": 1,
            "total_entries": 2,
            "per_page": 50
        },
        "users": [
            {
                "id": "USREC5",
                "email": "foo.bar@gmail.com",
                "firstname": "Foo",
                "lastname": "Bar",
                "is_verified": 0,
                "img": "http://example.com/profile.png",
                "creation_date": "2011-07-02T14:20:48Z",
                "last_login_date": "2012-09-22T01:55:49Z",
                "uri": "/v1/users/USREC5",
                "campaigns_uri": "/v1/users/USREC5/campaigns",
                "paid_campaigns_uri": "/v1/users/USREC5/paid_campaigns",
                "payments_uri": "/v1/users/USREC5/payments",
                "roles" : ["contributor"],
                "metadata": {}
            },
            .
            .
            .
        ]
    }

#### Response Codes

    200 => OK


### Update User

Currently, this request supports partial PUTs. For example, you can do a request
to update a single attribute without having to send the full
[user object](#user-definition).

    PUT /users/:id

    $ curl -XPUT -HContent-Type:application/json -u key:secret \
    http://api.crowdtilt.com/v1/users/USREC5 \
    -d'
    {
        "user": {
            "lastname": "new last name"
        }
    }'

#### Response Body

    {
        "user": {
            "id": "USREC5",
            "email": "foo.bar@gmail.com",
            "firstname": "Foo",
            "lastname": "new last name",
            "is_verified": 0,
            "img": "http://example.com/profile.png",
            "creation_date": "2011-07-02T14:20:48Z",
            "last_login_date": "2012-09-22T01:55:49Z",
            "uri": "/v1/users/USREC5",
            "campaigns_uri": "/v1/users/USREC5/campaigns",
            "paid_campaigns_uri": "/v1/users/USREC5/paid_campaigns",
            "payments_uri": "/v1/users/USREC5/payments",
            "roles" : ["contributor"],
            "metadata": {}
        }
    }

#### Response Codes

    200 => OK


## User Campaigns

### Get User Campaigns

This resource returns all the campaigns that the user has created as well as the
campaigns that he paid for.

    GET /users/:id/campaigns

    $ curl -u key:secret \
    https://api.crowdtilt.com/v1/users/USREC5/campaigns

#### Response Body

    {
        "pagination": {
            "total_pages": 0,
            "page": 1,
            "total_entries": 0,
            "per_page": 50
        },
        "campaigns": [
            {
                "id": "CMPBDA",
                "user_id": "USREC5",
                "title": "Campaign Title",
                "description": "some description",
                "privacy": 1,
                "tilt_amount": 100,
                "min_payment_amount": 0,
                "fixed_payment_amount": 0,
                "expiration_date": "2000-01-02T01:02:03Z",
                "is_tilted": 0,
                "is_paid": 0,
                "is_expired": 0,
                "tax_id": null,
                "tax_name": null,
                "uri": "/v1/campaigns/CMPBDA",
                "payments_uri": "/v1/campaigns/CMPBDA/payments",
                "admin": { "id": "USREC5", "uri": "/v1/users/USREC5", ... },
                "metadata": { },
                "stats": {
                    "tilt_percent": 0,
                    "raised_amount": 0,
                    "unique_contributors": 0,
                    "number_of_payments": 0
                }
            },
            .
            .
            .
        ]
    }

#### Response Codes

    200 => OK


### Get User Campaign

This resource returns a specific campaign created by this user.

    GET /users/:id/campaigns/:id

    $ curl -u key:secret \
    https://api.crowdtilt.com/v1/users/USREC5/campaigns/CMP96B

#### Response Body

    {
       "campaign" : {
          "img" : null,
          "metadata" : { },
          "id" : "CMP96B",
          "is_paid" : 0,
          "privacy" : 1,
          "is_expired" : 1,
          "fixed_payment_amount" : 0,
          "tilt_amount" : 100,
          "description" : "some description",
          "uri" : "/v1/campaigns/CMP96B",
          "creation_date" : "2012-10-19T15:09:01.869085000Z",
          "first_contributor" : { "id" : "USR123", "uri" : "/v1/users/USR123", ... },
          "tilter" : { "id" : "USR456", "uri" : "/v1/users/USR456", ... },
          "user_id" : "USR521",
          "title" : "some title",
          "modification_date" : "2012-10-19T15:09:01.869085000Z",
          "stats" : {
             "tilt_percent" : 0,
             "raised_amount" : 0,
             "unique_contributors" : 0,
             "number_of_payments" : 0
          },
          "expiration_date" : "2000-01-02T01:02:03Z",
          "is_tilted" : 0,
          "admin": { "id": "USREC5", ... },
          "min_payment_amount" : 0,
          "tax_id" : null,
          "tax_name" : null,
          "payments_uri" : "/v1/campaigns/CMP96B/payments"
       }
    }

#### Response Codes

    200 => OK


### Get User Paid Campaigns

This resource returns all the campaigns that the user paid for.

    GET /users/:id/paid_campaigns

    $ curl -u key:secret \
    https://api.crowdtilt.com/v1/users/USREC5/campaigns/CMP96B

#### Response Body

    {
        "pagination": {
            "total_pages": 0,
            "page": 1,
            "total_entries": 0,
            "per_page": 50
        },
        "campaigns": [
            {
                "id": "CMPBDA",
                "user_id": "USREC5",
                "title": "Campaign Title",
                "description": "some description",
                "privacy": 1,
                "tilt_amount": 100,
                "min_payment_amount": 0,
                "fixed_payment_amount": 0,
                "expiration_date": "2000-01-02T01:02:03Z",
                "is_tilted": 0,
                "is_paid": 0,
                "is_expired": 0,
                "tax_id": null,
                "tax_name": null,
                "uri": "/v1/campaigns/CMPBDA",
                "admin": { "id": "USREC5", "uri": "/v1/users/USREC5", ... },
                "payments_uri": "/v1/campaigns/CMPBDA/payments",
                "metadata": { },
                "stats": {
                    "tilt_percent": 0,
                    "raised_amount": 0,
                    "unique_contributors": 0,
                    "number_of_payments": 0
                }
            },
            .
            .
            .
        ]
    }

#### Response Codes

    200 => OK

## User Cards

### Create User Card

    POST /users/:id/cards

    $ curl -XPOST -u key:secret -HContent-Type:application/json\
    https://api.crowdtilt.com/v1/users/USR50A/cards\
    -d'
    {
        "card": {
            "expiration_year":2023,
            "security_code":123,
            "expiration_month":"01",
            "card_number":"4111111111111111"
        }
    }
    '

#### Response Body

    {
        "cards" : [
              {
                 "last_four" : "1111",
                 "expiration_year" : 2023,
                 "expiration_month" : "01",
                 "user": { "id" : "USR50A", "uri" : "/v1/users/USR50A", ... },
                 "uri" : "/v1/users/USR50A/cards/CCP6D6",
                 "card_type" : "VISA card",
                 "creation_date" : "2012-08-23T07:42:46.134467000Z",
                 "metadata" : {},
                 "id" : "CCP6D6E7E7C0C5C11E2BD7001E2CFE628C0"
              },
              ...
          ]
    }

#### Response Codes

    201 => Created


### Get User Card

    GET /users/:id/cards/:id

    $ curl -u key:secret \
    https://api.crowdtilt.com/v1/users/USR50A/cards/CCP6D6

#### Response Body

    {
        "card": {
            "last_four" : "1234",
                "expiration_year" : 2034,
                "expiration_month" : "04",
                "user": { "id" : "USR50A", "uri" : "/v1/users/USR50A", ... },
                "uri" : "/v1/users/USR50A/cards/CCP6D6",
                "card_type" : null,
                "creation_date" : "2012-08-23T07:42:46.134467000Z",
                "metadata" : {},
                "id" : "CCP6D6E7E7C0C5C11E2BD7001E2CFE628C0"
        }
    }

#### Response Codes

    200 => OK


### List User Cards

#### Request

    GET /users/:id/cards

#### Response Body

    {
        "pagination": {
            "total_pages": 0,
            "page": 1,
            "total_entries": 0,
            "per_page": 50
        },
        "cards": []
    }

#### Response Codes

    200 => OK


### Update User Card

Card information cannot be updated once it is set.  You can however, modify
the `metadata` of a Card. That is the only thing modifiable with this
request.  Other fields submitted will be ignored.

    PUT /users/:id/cards/:id

#### Request Body

    {
        "card": {
            "metadata" : {
                "key1" : "value1"
            }
        }
    }

#### Response Body

    {
        "card": {
            "last_four" : "1234",
                "expiration_year" : 2034,
                "expiration_month" : "04",
                "user": { "id": "USR50A", ... },
                "uri" : "/v1/users/USR50A/cards/CCP6D6",
                "card_type" : null,
                "creation_date" : "2012-08-23T07:42:46.134467000Z",
                "metadata" : {
                    "key1" : "value1"
                },
                "id" : "CCP6D6E7E7C0C5C11E2BD7001E2CFE628C0"
        }
    }

#### Response Codes

    200 => OK


### Delete User Card

    DELETE /users/:id/cards/:id

#### Response Codes

    200 => OK


## User Banks

### Create User Bank

    POST /users/:id/banks

#### Response Body

    {
        "bank": {
            "account_number_last_four" : "1234",
            "metadata" : {},
            "id" : "BAP688E65FA0C6D11E28914FE5E5CD73F12",
            "name" : "John Doe",
            "user": { "id" : "USR54B", "uri" : "/v1/users/USR54B", ... },
            "bank_code_last_four" : "1234",
            "uri" : "/v1/users/USR54B/banks/BAP688"
        }
    }

#### Response Codes

    201 => Created


### Get User Bank

    GET /users/:id/banks/:id

#### Response Body

    {
        "bank" : {
            "account_number_last_four" : "1234",
            "metadata" : {},
            "id" : "BAP688E65FA0C6D11E28914FE5E5CD73F12",
            "name" : "John Doe",
            "user": { "id" : "USR54B", "uri" : "/v1/users/USR54B", ... },
            "bank_code_last_four" : "1234",
            "uri" : "/v1/users/USR54B/banks/BAP688"
        }
    }

#### Response Codes

    200 => OK


### List User Banks

This resource lists the bank accounts associated with this user.

    GET /users/:id/banks

#### Response Body

    {
        "pagination": {
            "total_pages": 0,
            "page": 1,
            "total_entries": 0,
            "per_page": 50
        },
        "banks": [
            {
                "account_number_last_four" : "1234",
                "metadata" : {},
                "id" : "BAP688E65FA0C6D11E28914FE5E5CD73F12",
                "name" : "John Doe",
                "user": { "id" : "USR54B", "uri" : "/v1/users/USR54B", ... },
                "bank_code_last_four" : "1234",
                "uri" : "/v1/users/USR54B/banks/BAP688"
            }
        ]
    }

#### Response Codes

    200 => OK


### Update User Bank

Bank information cannot be updated once it is set.  You can however, modify
the `metadata` of a bank account. That is the only thing modifiable with this
request.  Other fields submitted will be ignored.

    PUT /users/:id/banks/:id

#### Request Body

    {
        "bank" : {
            "metadata" : {
                "key1" : "value1"
            }
        }
    }

#### Response Body

    {
        "bank" : {
            "account_number_last_four" : "1234",
            "metadata" : {
                "key1" : "value1"
            },
            "id" : "BAP688E65FA0C6D11E28914FE5E5CD73F12",
            "name" : "John Doe",
            "user": { "id" : "USR54B", "uri" : "/v1/users/USR54B", ... },
            "bank_code_last_four" : "1234",
            "uri" : "/v1/users/USR54B/banks/BAP688"
        }
    }

#### Response Codes

    200 => OK


### Delete User Bank

    DELETE /users/:id/banks/:id

### Response Codes

    200 => OK


## User Payments

### List User Payments

    GET /users/:id/payments

#### Response Body

    {
        "pagination": {
            "total_pages": 0,
            "page": 1,
            "total_entries": 0,
            "per_page": 50
        },
        "payments": []
    }

#### Response Codes

    200 => OK


## Campaign Resources

* [Campaigns](#campaigns)
* [Campaign Payments](#campaign-payments)
* [Refunds](#refunds)
* [Campaign Settlements](#campaign-payments)
* [Campaign Comments](#campaign-comments)

<table>
    <thead>
        <tr>
            <th>Path</th>
            <th>HTTP Methods</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>/campaigns</td>
            <td>
                <a href="#list-campaigns">GET</a>
                <a href="#create-campaign">POST</a>
            </td>
            <td> List of campaigns </td>
        </tr>
        <tr>
            <td>/campaigns/:id</td>
            <td>
                <a href="#get-campaign">GET</a>
                <a href="#update-campaign">PUT</a>
            </td>
            <td> A specific campaign </td>
        </tr>
        <tr>
            <td>/campaigns/:id/payments</td>
            <td>
                <a href="#get-campaign-payments">GET</a>
                <a href="#create-campaign-payment">POST</a>
            </td>
            <td> Campaign Payments </td>
        </tr>
        <tr>
            <td>/campaigns/:id/payments/:id</td>
            <td>
                <a href="#get-campaign-payment">GET</a>
            </td>
            <td> Details about a specific payment </td>
        </tr>
        <tr>
            <td>/campaigns/:id/payments/:id/refund</td>
            <td>
                <a href="#refund-a-payment">POST</a>
            </td>
            <td> Refunding a specific payment </td>
        </tr>
        <tr>
            <td>/campaigns/:id/settlements</td>
            <td>
                <a href="#get-campaign-settlements">GET</a>
            </td>
            <td> Campaign Settlements </td>
        </tr>
        <tr>
            <td>/campaigns/:id/settlements/:id</td>
            <td>
                <a href="#list-campaign-settlement">GET</a>
            </td>
            <td> Campaign Settlement </td>
        </tr>
        <tr>
            <td>/campaigns/:id/settlements/:id/bank</td>
            <td>
                <a href="#update-campaign-settlement-bank">POST</a>
            </td>
            <td> Update a Campaign Settlement Bank </td>
        </tr>
        <tr>
            <td>/campaigns/:id/comments</td>
            <td>
                <a href="#get-campaign-comments">GET</a>
                <a href="#create-campaign-comment">POST</a>
            </td>
            <td> Campaign Comments </td>
        </tr>
        <tr>
            <td>/campaigns/:id/comments/:id</td>
            <td>
                <a href="#get-campaign-comment">GET</a>
                <a href="#update-campaign-comment">PUT</a>
                <a href="#delete-campaign-comment">DELETE</a>
            </td>
            <td> Details about (or delete) a specific comment </td>
        </tr>
    </tbody>
</table>


## Campaigns

### Create Campaign

A campaign needs to be associated to a user. We refer to this user as the
"campaign admin". Campaign admins can create campaigns without having to be
verified. However, they need to be
[verified](#verify-user) in order to [set up their bank account details](#create-user-bank)
and then be able to receive the money collected in their campaign.

    POST /campaigns

#### Request Body

    {
        "campaign": {
            "user_id":"USREC5",
            "title":"Campaign Title",
            "description":"some description",
            "expiration_date":"2000-01-02T01:02:03Z",
            "tilt_amount":100
        }
    }

#### Response Body

    {
        "campaign": {
            "id": "CMPBDA",
            "user_id": "USREC5",
            "title": "Campaign Title",
            "description": "some description",
            "privacy": 1,
            "type": 1,
            "tilt_amount": 100,
            "min_payment_amount": 0,
            "fixed_payment_amount": 0,
            "expiration_date": "2000-01-02T01:02:03Z",
            "creation_date": "2000-01-02T01:02:03Z",
            "modification_date": "2000-01-02T01:02:03Z",
            "img": null,
            "is_tilted": 0,
            "is_paid": 0,
            "is_expired": 0,
            "tax_id": null,
            "tax_name": null,
            "uri": "/v1/campaigns/CMPBDA",
            "admin": { "id": "USREC5", "uri": "/v1/users/USREC5", ... },
            "payments_uri": "/v1/campaigns/CMPBDA/payments",
            "metadata": { },
            "stats": {
                "tilt_percent": 0,
                "raised_amount": 0,
                "unique_contributors": 0,
                "number_of_payments": 0
            }
        }
    }

#### Response Codes

    201 => Created


### Get Campaign

    GET  /campaigns/:id

#### Response Body

    {
        "campaign": {
            "id": "CMPBDA",
            "user_id": "USREC5",
            "title": "Campaign Title",
            "description": "some description",
            "privacy": 1,
            "type": 1,
            "tilt_amount": 100,
            "min_payment_amount": 0,
            "fixed_payment_amount": 0,
            "expiration_date": "2000-01-02T01:02:03Z",
            "creation_date": "2000-01-02T01:02:03Z",
            "modification_date": "2000-01-02T01:02:03Z",
            "img": "http://url.to/img.jpg",
            "is_tilted": 0,
            "is_paid": 0,
            "is_expired": 0,
            "tax_id": null,
            "tax_name": null,
            "uri": "/v1/campaigns/CMPBDA",
            "admin": { "id": "USREC5", "uri": "/v1/users/USREC5", ... },
            "payments_uri": "/v1/campaigns/CMPBDA/payments",
            "metadata": { },
            "stats": {
                "tilt_percent": 0,
                "raised_amount": 0,
                "unique_contributors": 0,
                "number_of_payments": 0
            }
        }
    }

#### Response Codes

    200 => OK


### List campaigns

    GET /campaigns

#### Response Body

    {
        "pagination": {
            "total_pages": 34337,
            "page": 1,
            "total_entries": 1716893,
            "per_page": 50
        },
        "campaigns": [
            {
                "id": "CMPBDA",
                "user_id": "USREC5",
                "title": "Campaign Title",
                "description": "some description",
                "privacy": 1,
                "type": 1,
                "tilt_amount": 100,
                "min_payment_amount": 0,
                "fixed_payment_amount": 0,
                "expiration_date": "2000-01-02T01:02:03Z",
                "creation_date": "2000-01-02T01:02:03Z",
                "modification_date": "2000-01-02T01:02:03Z",
                "img": "http://url.to/img.jpg",
                "is_tilted": 0,
                "is_paid": 0,
                "is_expired" : 0,
                "tax_id": null,
                "tax_name": null,
                "uri": "/v1/campaigns/CMPBDA",
                "admin": { "id": "USREC5", "uri": "/v1/users/USREC5", ... },
                "payments_uri": "/v1/campaigns/CMPBDA/payments",
                "metadata": { },
                "stats": {
                    "tilt_percent": 0,
                    "raised_amount": 0,
                    "unique_contributors": 0,
                    "number_of_payments": 0
                }
            },
            .
            .
            .
        ]
    }

#### Response Codes

    200 => OK


### Update Campaign

Currently, this request supports partial PUTs. For example, you can do a request
to update a single attribute without having to send the full [campaign object](/Crowdtilt/crowdtilt-api-spec/blob/master/objects/README.md#campaign).

    PUT /campaigns/:id

#### Response Body

    {
        "campaign": {
            "id": "CMPBDA",
            "user_id": "USREC5",
            "title": "Campaign Title",
            "description": "some description",
            "privacy": 1,
            "type": 1,
            "tilt_amount": 100,
            "min_payment_amount": 0,
            "fixed_payment_amount": 0,
            "expiration_date": "2000-01-02T01:02:03Z",
            "creation_date": "2000-01-02T01:02:03Z",
            "modification_date": "2000-01-02T01:02:03Z",
            "img": "http://url.to/img.jpg",
            "is_tilted": 0,
            "is_paid": 0,
            "is_expired": 0,
            "tax_id": null,
            "tax_name": null,
            "uri": "/v1/campaigns/CMPBDA",
            "admin": { "id": "USREC5", "uri": "/v1/users/USREC5", ... },
            "payments_uri": "/v1/campaigns/CMPBDA/payments",
            "metadata": { },
            "stats": {
                "tilt_percent": 0,
                "raised_amount": 0,
                "unique_contributors": 0,
                "number_of_payments": 0
            }
        }
    }

#### Response Codes

    200 => OK


## Campaign Payments

### Create campaign payment

Before a user is able to contribute, they need to have a Credit Card associated
to them.  All amounts and prices used in this API are *always* in cents.

When creating a payment, the `amount` field determines how much money is
going to the campaign.  The `user_fee_amount` accepts a value that will be
charged to the paying user, on top of the `amount`, and the `admin_fee_amount`
will be taken out of the money that goes to the campaign admin when the campaign
tilts.

For example, if a user wants to pay `$20.00` to a campaign, and you want to add
a 2% fee to the user, you would send `amount` as `2000` and `user_fee_amount` as
`40` (2% of the `$20.00`).  The users credit card would then be charged
`$20.40`.  In the same scenario, if you wanted to charge 2% from the admin
when the campaign tilts, you would set `admin_fee_amount` to `40` and on tilt
the admin will only receive `$19.60` from the `$20.00` payment.

    POST /campaigns/:id/payments

    {
        "payment": {
            "amount" : 2000,
            "user_fee_amount" : 40,
            "admin_fee_amount" : 40,
            "user_id": "USR521",
            "card_id": "CCPC41"
        }
    }


#### Response Body

    {
       "payment" : {
          "status" : "charged",
          "modification_date" : "2012-10-20T15:45:47Z",
          "metadata" : {},
          "id" : "CON233",
          "uri" : "/v1/campaigns/CMP96B/payments/CON233",
          "amount" : 2000,
          "user_fee_amount" : 40,
          "admin_fee_amount" : 40,
          "creation_date" : "2012-10-20T15:45:13Z",
          "campaign" : { "id": "CMP96B", "uri" : "/v1/campaigns/CMP96B", ... },
          "card" : { "id" : "CCPC41", "uri" : "/v1/users/USR521/cards/CCPC41", ... },
          "user": { "id" : "USR521", "uri" : "/v1/users/USR521", ... },
       }
    }

#### Response Codes

    201 => Created


### Get campaign payment

    GET /campaigns/:id/payments/:id

#### Response Body

    {
       "payment" : {
          "status" : "charged",
          "modification_date" : "2012-10-20T15:45:47Z",
          "metadata" : {},
          "id" : "CON233",
          "uri" : "/v1/campaigns/CMP96B/payments/CON233",
          "amount" : 2000,
          "user_fee_amount" : 40,
          "admin_fee_amount" : 40,
          "creation_date" : "2012-10-20T15:45:13Z",
          "campaign" : { "id": "CMP96B", "uri" : "/v1/campaigns/CMP96B", ... },
          "card" : { "id" : "CCPC41", "uri" : "/v1/users/USR521/cards/CCPC41", ... },
          "user": { "id" : "USR521", "uri" : "/v1/users/USR521", ... },
       }
    }

#### Response Codes

    200 => OK



### Get campaign payments

    GET /campaigns/:id/payments

#### Response Body

    {
       "payments" : [
          {
             "status" : "charged",
             "modification_date" : "2012-10-20T15:45:47Z",
             "metadata" : {},
             "id" : "CON233",
             "uri" : "/v1/campaigns/CMP96B/payments/CON233",
             "amount" : 2000,
             "user_fee_amount" : 40,
             "admin_fee_amount" : 40,
             "creation_date" : "2012-10-20T15:45:13Z",
             "campaign" : { "id": "CMP96B", "uri" : "/v1/campaigns/CMP96B", ... },
             "card" : { "id" : "CCPC41", "uri" : "/v1/users/USR521/cards/CCPC41", ... },
             "user": { "id" : "USR521", "uri" : "/v1/users/USR521", ... },
          }
       ],
       "pagination" : {
          "total_pages" : 1,
          "page" : 1,
          "total_entries" : 1,
          "per_page" : 50
       }
    }

#### Response Codes

    200 => OK

## Refunds

### Refund a payment

In order to refund a payment, simply POST with an empty body to the payment's
refund subresource.

    POST /campaigns/:id/payments/:id/refund

    $ curl -XPOST -u key:secret \
    http://localhost:5003/v1/campaigns/CMP96B/payments/CON233/refund

#### Response Codes

    200 => OK

## Campaign Settlements

Campaign Settlements represent a disbursement of funds for a tilted campaign.
A campaign settlement will show you the `campaign`, `bank`, and `user` that the
`settlement` belongs to.  It will also show you the `admin_amount`, which is the
amount of money being sent to the admin's bank account.  The `escrow_amount`
is how much money from the campaign is going into your escrow account (it
represents fees charged to the admin and payers).  Possible statuses for a
campaign settlement are:

* `needs bank account` - this means that admin of the campaign needs to set up
  his or her bank account before the funds will be sent.
* `pending` - this means that the funds are being transfered to the bank account
  specified in the settlement.
* `rejected` - this means that the settlement was rejected and could not be
  sent to the bank account in question.  In these cases, the bank account
  can be updated, as specified in the
  [update campaign settlement](#update-campaign-settlement-bank) section.
* `re-sent pending` - this means that the settlement previously failed, but the
  bank account has been updated, and the funds are being transfered to the new
  bank account.
* `cleared` - this means that the funds have cleared the bank account and the
  settlement has completed successfully.

### List Campaign Settlements

    GET /campaigns/:id/settlements

#### Response

    "settlements" : [
        {
            "id" : "SMTD88",
                "status" : "pending",
                "admin_amount" : 1960,
                "escrow_amount" : 40,
                "modification_date" : "2012-10-29T15:34:48.177091000Z",
                "creation_date" : "2012-10-29T15:34:48.177091000Z",
                "bank" : { "id" : "BAPCA3", "uri" : "/v1/users/USRC77/banks/BAPCA3", ... },
                "campaign" : { "id" : "CMPCCC", "uri" : "/v1/campaigns/CMPCCC", ... },
                "user" : { "id" : "USRC7B", "uri" : "/v1/users/USRC7B", ... }
        },
        .
        .
        .
    ],
    "pagination" : {
        "total_pages" : 1,
        "page" : 1,
        "total_entries" : 1,
        "per_page" : 50
    }


### Get Campaign Settlement

    GET /campaigns/:id/settlements/:id

#### Response

    {
        "settlement" : {
            "id" : "SMTD88",
                "status" : "pending",
                "admin_amount" : 1960,
                "escrow_amount" : 40,
                "modification_date" : "2012-10-29T15:34:48.177091000Z",
                "creation_date" : "2012-10-29T15:34:48.177091000Z",
                "bank" : { "id" : "BAPCA3", "uri" : "/v1/users/USRC77/banks/BAPCA3", ... },
                "campaign" : { "id" : "CMPCCC", "uri" : "/v1/campaigns/CMPCCC", ... },
                "user" : { "id" : "USRC7B", "uri" : "/v1/users/USRC7B", ... }
        }
    }

### Update Campaign Settlement Bank

A Campaign Settlement can only be updated if the status is `needs bank account`.
In this instance, a `bank` object can be sent with the `id` of a new bank
account to re-attempt the settlement with.

    POST /campaigns/:id/settlements/:id/bank

#### Request

    {
        "bank" : { "id" : "BAPCA4" }
    }

## Campaign Comments

### Create Campaign Comment

To create a comment, POST to `/campaigns/:id/comments`.
The only required fields are the `user_id` of the comment author
and the `body` of the comment.
The `title`, `parent_id`, and `score` fields are optional.
The `parent_id` is the id of the parent of this comment, i.e.,
the comment that this comment is a reply to.
This only matters if you want to support nested comments.
You may provide a `parent_id` of null for top-level comments.
The purpose of the `score` field is to provide support for voting on comments.

    POST /campaigns/:id/comments

    {
        "comment" : {
            "user_id' : "USR123",
            "title" : "Optional Title",
            "body" : "Comment Body",
            "score" : 1,
            "parent_id" : null
        }
    }

#### Response

    {
        "comment" : {
            "id" : "CMT123",
            "user_id' : "USR123",
            "title" : "Optional Title",
            "body" : "Comment Body",
            "score" : 1,
            "parent_id" : null,
            "metadata" : { },
            "creation_date" : "2012-10-01T00:00:00Z",
            "modification_date" : "2012-10-01T00:00:00Z"
        }
    }

#### Response Codes

    200 => OK

### Get Campaign Comments

#### Response

    {
        "comments" : [
            {
                "id" : "CMT123",
                "user_id' : "USR123",
                "title" : "Optional Title",
                "body" : "Comment Body",
                "score" : 1,
                "parent_id" : null,
                "metadata" : { },
                "creation_date" : "2012-10-01T00:00:00Z",
                "modification_date" : "2012-10-01T00:00:00Z"
            },
            ...
        ]
    }

#### Response Codes

    200 => OK

### Get campaign comment

    GET /campaigns/:id/comments/:id

#### Response

    {
        "comment" : {
            "id" : "CMT123",
            "user_id' : "USR123",
            "title" : "Optional Title",
            "body" : "Comment Body",
            "score" : 1,
            "parent_id" : null,
            "metadata" : { },
            "creation_date" : "2012-10-01T00:00:00Z",
            "modification_date" : "2012-10-01T00:00:00Z"
        }
    }

#### Response Code

    200 => OK

### Update campaign comment

Currently you can only alter the score and the metadata of a comment.

    PUT /campaigns/:id/comments/:id

#### Request

    {
        "comment" : {
            "score" : 2,
            "metadata" : {
                "key" : "value",
            }
        }
    }

#### Response

    {
        "comment" : {
            "id" : "CMT123",
            "user_id' : "USR123",
            "title" : "Optional Title",
            "body" : "Comment Body",
            "score" : 2,
            "parent_id" : null,
            "metadata" : {
                "key" : "value",
            },
            "creation_date" : "2012-10-01T00:00:00Z",
            "modification_date" : "2012-10-01T00:00:00Z"
        }
    }

#### Response Code

    200 => OK

### Delete a comment

    DELETE /campaigns/:id/comments/:id

#### Response Codes

    200 => OK

## Examples
TODO: Fill


## User Definition

<table>
    <thead>
        <tr>
            <th>Attribute</th>
            <th>Type</th>
            <th>Required</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>string</td>
            <td>Auto generated and read-only</td>
            <td>A unique identifier for the user</td>
        </tr>
        <tr>
            <td>email</td>
            <td>string</td>
            <td>Yes</td>
            <td>Email address</td>
        </tr>
        <tr>
            <td>firstname</td>
            <td>string</td>
            <td>Yes</td>
            <td>The first name of the user</td>
        </tr>
        <tr>
            <td>lastname</td>
            <td>string</td>
            <td>Yes</td>
            <td>The last name of the user</td>
        </tr>
        <tr>
            <td>is_verified</td>
            <td>integer</td>
            <td>Auto generated and read-only</td>
            <td>Whether this user is verified to receive money</td>
        </tr>
        <tr>
            <td>img</td>
            <td>string</td>
            <td>No</td>
            <td>A url for user's image</td>
        </tr>
        <tr>
            <td>creation_date</td>
            <td>string</td>
            <td>Auto generated and read-only</td>
            <td>It is ISO8601 DateTime format</td>
        </tr>
        <tr>
            <td>last_login_date</td>
            <td>string</td>
            <td>Auto generated and read-only</td>
            <td>It is ISO8601 DateTime format</td>
        </tr>
        <tr>
            <td>metadata</td>
            <td>JSON object</td>
            <td>No</td>
            <td>Key-Value pair for any extra data the API consumer wants to store.</td>
        </tr>
        <tr>
            <td>uri</td>
            <td>string</td>
            <td>Auto generated and read-only</td>
            <td>The uri for this user resource</td>
        </tr>
        <tr>
            <td>campaigns_uri</td>
            <td>string</td>
            <td>Auto generated and read-only</td>
            <td>The uri for listing user's campaigns</td>
        </tr>
        <tr>
            <td>paid_campaigns_uri</td>
            <td>string</td>
            <td>Auto generated and read-only</td>
            <td>The uri for listing the campaigns the user paid for</td>
        </tr>
        <tr>
            <td>payments_uri</td>
            <td>string</td>
            <td>Auto generated and read-only</td>
            <td>The uri for the user's payments</td>
        </tr>
    </tbody>
</table>


## Campaign Definition

<table>
    <thead>
        <tr>
            <th>Attribute</th>
            <th>Type</th>
            <th>Required</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>string</td>
            <td>Auto generated and read-only</td>
            <td>A unique identifier for the campaign</td>
        </tr>
        <tr>
            <td>user_id</td>
            <td>string</td>
            <td>Yes</td>
            <td>The id of the campaign admin</td>
        </tr>
        <tr>
            <td>title</td>
            <td>string</td>
            <td>Yes</td>
            <td>The title of the campaign</td>
        </tr>
        <tr>
            <td>description</td>
            <td>string</td>
            <td>Yes</td>
            <td>The description of the campaign</td>
        </tr>
        <tr>
            <td>is_expired</td>
            <td>number</td>
            <td>No</td>
            <td>Whether or not the campaign is expired
                <table>
                    <tr>
                        <td>Value</td>
                        <td>Description</td>
                    </tr>
                    <tr>
                        <td>0</td>
                        <td>Not Expired</td>
                    </tr>
                    <tr>
                        <td>1</td>
                        <td>Expired</td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>privacy</td>
            <td>number</td>
            <td>No</td>
            <td>The privacy settings for the campaign. It defaults to 1.
            Available values
                <table>
                    <tr>
                        <td>Value</td>
                        <td>Description</td>
                    </tr>
                    <tr>
                        <td>0</td>
                        <td>public</td>
                    </tr>
                    <tr>
                        <td>1</td>
                        <td>private</td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>tilt_amount</td>
            <td>number</td>
            <td>Yes</td>
            <td>The amount required to tilt the campaign. This amount is in
            cents. After the campaign raises enough funds equal or more than
            this amount, the credit cards will get charged. Before that, cards
            are authorized only.
            </td>
        </tr>
        <tr>
            <td>min_payment_amount</td>
            <td>number</td>
            <td>No</td>
            <td>The minimum amount for a single payment. This amount is in
            cents.</td>
        </tr>
        <tr>
            <td>fixed_payment_amount</td>
            <td>number</td>
            <td>No</td>
            <td>If this amount is set, each payment will have to be exactly
            this amount or multiples of it. This amount is in cents.</td>
        </tr>
        <tr>
            <td>expiration_date</td>
            <td>String. ISO8601 DateTime format</td>
            <td>Yes</td>
            <td>The expiration date of the campaign</td>
        </tr>
        <tr>
            <td>creation_date</td>
            <td>String. ISO8601 DateTime format</td>
            <td>Auto generated and read-only</td>
            <td>The creation date of the campaign</td>
        </tr>
        <tr>
            <td>modification_date</td>
            <td>String. ISO8601 DateTime format</td>
            <td>Auto generated and read-only</td>
            <td>The modification date of the campaign</td>
        </tr>
        <tr>
            <td>is_tilted</td>
            <td>number</td>
            <td>Read-only</td>
            <td>Indicates whether or not the campaign has tilted</td>
        </tr>
        <tr>
            <td>is_paid</td>
            <td>number</td>
            <td>Read-only</td>
            <td>Indicates whether or not the campaign funds has been paid to the
            admin</td>
        </tr>
        <tr>
            <td>type</td>
            <td>number</td>
            <td>No</td>
            <td>The type of the campaign. Available values
                <table>
                    <tr>
                        <td>Value</td>
                        <td>Description</td>
                    </tr>
                    <tr>
                        <td>1</td>
                        <td>Friendly</td>
                    </tr>
                    <tr>
                        <td>2</td>
                        <td>non-profit</td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>tax_id</td>
            <td>string</td>
            <td>No</td>
            <td>The EIN for a business or non-profit organization. This
            attribute is required only if the campaign type is a non-profit.
            </td>
        </tr>
        <tr>
            <td>tax_name</td>
            <td>string</td>
            <td>No</td>
            <td>The name of the business or non-profit</td>
        </tr>
        <tr>
            <td>uri</td>
            <td>string</td>
            <td>Auto generated and read-only</td>
            <td>The uri for this campaign resource</td>
        </tr>
        <tr>
            <td>admin</td>
            <td>JSON object</td>
            <td>Auto generated and read-only</td>
            <td>This campaign's admin</td>
        </tr>
        <tr>
            <td>payments_uri</td>
            <td>string</td>
            <td>Auto generated and read-only</td>
            <td>The uri for the payments on this campaign</td>
        </tr>
        <tr>
            <td>metadata</td>
            <td>JSON object</td>
            <td>No</td>
            <td>Key-Value pair for any extra data the API consumer wants to store.</td>
        </tr>
    </tbody>
</table>


## Payment Definition

<table>
    <thead>
        <tr>
            <th>Attribute</th>
            <th>Type</th>
            <th>Required</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td>string</td>
            <td>Auto generated and read-only</td>
            <td>A unique identifier for the payment</td>
        </tr>
        <tr>
            <td>amount</td>
            <td>number</td>
            <td>Yes</td>
            <td>The amount of this payment</td>
        </tr>
        <tr>
            <td>status</td>
            <td>string</td>
            <td>Auto generated and read-only</td>
            <td>Reflects the status of the payment. Available values:
                <table>
                    <tr>
                        <td>authorized</td>
                    </tr>
                    <tr>
                        <td>charged</td>
                    </tr>
                    <tr>
                        <td>refunded</td>
                    </tr>
                    <tr>
                        <td>rejected</td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>creation_date</td>
            <td>String. ISO8601 DateTime format</td>
            <td>Auto generated and read-only</td>
            <td>The creation date of the payment</td>
        </tr>
        <tr>
            <td>modification_date</td>
            <td>String. ISO8601 DateTime format</td>
            <td>Auto generated and read-only</td>
            <td>The modification date of the payment</td>
        </tr>
        <tr>
            <td>uri</td>
            <td>string</td>
            <td>Auto generated and read-only</td>
            <td>The uri for this campaign resource</td>
        </tr>
        <tr>
            <td>user</td>
            <td>JSON object</td>
            <td>Auto generated and read-only</td>
            <td>The contributor of this payment</td>
        </tr>
        <tr>
            <td>card</td>
            <td>JSON object</td>
            <td>Auto generated and read-only</td>
            <td>The card used for this payment</td>
        </tr>
        <tr>
            <td>campaign</td>
            <td>JSON object</td>
            <td>Auto generated and read-only</td>
            <td>The campaign this payment is for</td>
        </tr>
        <tr>
            <td>metadata</td>
            <td>JSON object</td>
            <td>No</td>
            <td>Key-Value pair for any extra data the API consumer wants to store.</td>
        </tr>
    </tbody>
</table>



# Pagination

All ``GET`` requests on collection resources has pagination enabled with a default
of **50** entries per page. For example:

    GET /users

    {
        "pagination": {
            "total_pages": 2,
            "page": 1,
            "total_entries": 100,
            "per_page": 50
        },
        "users": [
            {
                "id": "USREC5",
                "email": "foo.bar@gmail.com",
                "firstname": "Foo",
                "lastname": "Bar",
                "img": "http://example.com/profile.png",
                "status": 1,
                "verified": 1,
                "creation_date": "2011-07-02T14:20:48Z",
                "last_login_date": "2012-09-22T01:55:49Z",
                "uri": "/v1/users/USREC5",
                "campaigns_uri": "/v1/users/USREC5/campaigns",
                "paid_campaigns_uri": "/v1/users/USREC5/paid_campaigns",
                "payments_uri": "/v1/users/USREC5/payments",
                "roles" : ["contributor"],
                "metadata": {}
            },
            .
            .
            .
        ]
    }

The default limits can be changed with ``per_page`` and ``page`` request
parameters. For example:

    GET /users?page=2&per_page=10
