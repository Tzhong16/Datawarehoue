--check different 
USE DW4;
EXEC pCheckDifferent;

--Update Customer Address in Source Datebase
USE AdventureWorks2014;
EXEC updatecustomerAddressIndataSource;

--check different 
USE DW4;
EXEC pCheckDifferent;

--Update destination table
USE DW4;
EXEC updatecustomerAddressInDestinationDataBase;

--check different 
USE DW4;
EXEC pCheckDifferent;

--------------------------------------------------------

--UpdateBack Source Datebase
USE AdventureWorks2014;
EXEC BacktoOldCustomerInSourceDatebase;

--Update Back destination table
USE DW4;
EXEC BacktoOlddimcustomer;


--check different 
USE DW4;
EXEC pCheckDifferent;