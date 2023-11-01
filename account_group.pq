let
  APtable = "account_groups",
  version = "2.0",
  url = "https://api.bexio.com/",
  source = Json.Document( Web.Contents(url &  version &"/" &APtable,[
  Headers = [#"Accept"= "application/json",
    #"Authorization"= Tok] ] )),
  MakeTable = Table.FromList(source, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
  ExpRec = Table.FromRecords(MakeTable[Column1]),
  #"Transform columns" = Table.TransformColumnTypes(ExpRec, {{"id", type text}, {"uuid", type text}, {"account_no", Int64.Type}, {"name", type text}, {"parent_fibu_account_group_id", type text}, {"is_active", type text}, {"is_locked", type text}}),
  #"Replace errors" = Table.ReplaceErrorValues(#"Transform columns", {{"id", null}, {"uuid", null}, {"account_no", null}, {"name", null}, {"parent_fibu_account_group_id", null}, {"is_active", null}, {"is_locked", null}}),
  Custom = Table.AddColumn(#"Replace errors", "PLColumn", each if [account_no] = 34 then "Service revenues" else if
    [account_no] >= 36 and [account_no] <= 39 then "Other revenues from goods and services" else if
    [account_no] = 340 then "Service revenues" else if
    [account_no] >= 30 and [account_no] <= 32  then "Income from restaurant" else if
    [account_no] >= 300 and [account_no] <= 350  then "Income from restaurant" else if
    [account_no] >= 360 and [account_no] <= 399  then "Other revenues from goods and services" else if
    [account_no] >= 40 and [account_no] <= 43  then "Cost of goods for restaurant" else if
    [account_no] >= 400 and [account_no] <= 439  then "Cost of goods for restaurant" else if
    [account_no] = 450  then "Delivery fees" else if
    [account_no] >= 44 and [account_no] <= 45  then "Cost of purchased services" else if
    [account_no] >= 440 and [account_no] <= 459  then "Cost of purchased services" else if
    [account_no] >= 480 and [account_no] <= 480  then "Inventory changes for material or loss of goods" else if
    [account_no] >= 46 and [account_no] <= 49  then "Other Direct expenses" else if
    [account_no] >= 460 and [account_no] <= 499  then "Other Direct expenses" else if
    [account_no] = 50 or  [account_no] = 500  then "Salary expenses" else if
    [account_no] = 57 or  [account_no] = 570  then "Staff Charges" else if
    [account_no] = 58  then "Other staff charges" else if
    [account_no] >= 580 and [account_no] <= 588  then "Other staff charges" else if
    [account_no] = 589 then "Private share staff charges" else if
    [account_no] >= 60 and [account_no] <= 67  then "Rent, Rates & Administrative" else if
    [account_no] >= 600 and [account_no] <= 679  then "Rent, Rates & Administrative" else if
    [account_no] = 68   then "Other operating expenses, depreciations, value adjustments and financial results" else if
    [account_no] >= 680 and [account_no] <= 689  then "Other operating expenses, depreciations, value adjustments and financial results" else if
    [account_no] = 69   then "Operational side earnings" else if
    [account_no] >= 690 and [account_no] <= 699  then "Operational side earnings" else if
    [account_no] = 70   then "Earnings from ancillary operations" else if
    [account_no] >= 700 and [account_no] <= 799  then "Earnings from ancillary operations" else if
    [account_no] >= 80 and [account_no] <= 88   then "Non-operating/extraordinary/one-time revenue and expense or revenue and expenses for other accounting periods" else if
    [account_no] >= 800 and [account_no] <= 889  then "Non-operating/extraordinary/one-time revenue and expense or revenue and expenses for other accounting periods" else null),
  #"Transform columns 1" = Table.TransformColumnTypes(Custom, {{"PLColumn", type text}}),
  #"Replace errors 1" = Table.ReplaceErrorValues(#"Transform columns 1", {{"PLColumn", null}})
in
  #"Replace errors 1"