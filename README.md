## Black Thursday

Find the [project spec here](https://github.com/turingschool/curriculum/blob/master/source/projects/black_thursday.markdown).

Black Thursday is a database which adheres to the following structure:

- Sales Analyst

- Sales Engine
  - Merchant Repository
    - Merchants
  - Item Repository
    - Items
  - Invoice Repository
    - Invoices
  - Invoice Item Repository
    - Invoice Items
  - Transaction Repository
    - Transactions
  - Customer Repository
    - Customers

### Interaction

  The Sales Engine is capable of creating all 6 repositories using CSV files to populate them with their respective children. We've built in functionality that allows for some of the children to return data from other repository branches if it is relevant. i.e. merchants can find items they sell, items can find invoices they are associated with.

  Sales Analyst is a free standing unit that can be initialized with a specific sales engine. It provides the tools to run numerous analytics on the data living in the engine. i.e. finding standard deviations, total revenue of merchants, how many items merchants sell, etc. 
