
# TRIAL BALANCE SCRIPT

#   This script will take a Trial Balance in the form of .xlsx and create a new file called UpdatedTest
#   with amounts and lines for filling in a Tax Return given the information provided.

# Column names on Row 4 (AccountNums, AccountNames, Year1, Year2) 


# Install the following packages if not done already:
# install.packages("mosaic")
# install.packages("tidyverse")
# install.packages("readxl")
# install.packages("here")
# install.packages("dplyr")
# install.packages("stringr")
# install.packages("writexl")
# install.packages("DescTools")
# install.packages("openxlsx")

# Make sure libraries are availble for use
library(mosaic)
library(tidyverse)
library(readxl)
library(here)
library(dplyr)
library(stringr)
library(writexl)
library(DescTools)
library(xlsx)
library(staplr)
devtools::install_github("pridiltal/staplr")


# HIGHLIGHT EVERYTHING, AND CLICK "Run" :)




# ONLY CHANGE THIS if necessary 
# Read in the Trial Balance 
final <- read_xlsx(here::here("Data/Final.xlsx"), skip = 3) 

# final <- read_xlsx(here::here("Data/TrialBalanceTemplate.xlsx"), skip = 3) 




#### Set Up ####


# Rename columns
colnames(final) <- c("AccountNum", "AccountName", "Beginning", "End")

# Only keep the first 4 columns
final1 <- final %>% 
  select(AccountNum, AccountName, Beginning, End) 
  
# Change NA's to 0
final1$Beginning[is.na(final1$Beginning)] <- 0
  
# Create "Difference" column, which is the End minus the Beginning columns
final2 <- final1 %>% 
  mutate(Difference = (End - Beginning))
  
# Create empty "TaxAmount" and "TaxLine" columns
final3 <- final2 %>% 
  mutate(TaxAmount = NA) %>% 
  mutate(TaxLine = NA)

#### end ####


#### Write Excel File ####


# Fill in for Page 1 of Form 1065
final4 <- final2 %>%
  mutate(page1diff = case_when(
    final2$AccountNum == 41000 ~ paste(Difference, ", Form 1065 - Line 2") ,
    final2$AccountNum == 50000 ~ paste(Difference, ", Form 1065 - Line 9") ,
    final2$AccountNum == 50100 ~ paste(Difference, ", Form 1065 - Line 20") ,
    final2$AccountNum == 50300 ~ paste(Difference, ", Form 1065 - Line 13") ,
    final2$AccountNum == 50500 ~ paste(Difference, ", Form 1065 - Line 20") ,
    final2$AccountNum == 51100 ~ paste(Difference, ", Form 1065 - Line 20") ,
    final2$AccountNum == 51200 ~ paste(Difference, ", Form 1065 - Line 10") ,
    final2$AccountNum == 51300 ~ paste(Difference, ", Form 1065 - Line 20") ,
    final2$AccountNum == 51500 ~ paste(Difference, ", Form 1065 - Line 15") ,
    
    TRUE  ~ as.character(NA)))  
  
# Fill in for Schedule K
final4 <- final4 %>%
  mutate(SchKdif = case_when(
    final2$AccountNum == 51200 ~ paste(Difference, ", Schedule K - Line 4") ,
    final2$AccountNum == 32000 ~ paste(Difference, ", Schedule K - Line 5") ,
    final2$AccountNum == 33000 ~ paste(Difference, ", Schedule K - Line 6") ,
    final2$AccountNum == 50200 ~ paste(Difference, ", Schedule K - Line 13a") ,
    final2$AccountNum == 34000 ~ paste(Difference, ", Schedule K - Line 9a") ,
    final2$AccountNum == 34001 ~ paste(Difference, ", Schedule K - Line 8") ,
    final2$AccountNum == 17100 ~ paste(End, ", Schedule L - Line 9a(c)") ,
    final2$AccountNum == 41000 ~ paste(End, ", Form 1125-A - Line 2") ,
    TRUE  ~ as.character(NA))) 

# Fill in for Schedule L - Beginning
final4 <- final4 %>%
  mutate(SchLbeg = case_when(
    final2$AccountNum == 10100 ~ paste(Beginning, ", Schedule L - Line 1(b)") ,
    final2$AccountNum == 19100 ~ paste(Beginning, ", Schedule L - Line 11(b)") ,
    final2$AccountNum == 21000 ~ paste(Beginning, ", Schedule L - Line 15(b)") ,
    final2$AccountNum == 27000 ~ paste(Beginning, ", Schedule L - Line 21(b)") ,
    final2$AccountNum == 24000 ~ paste(Beginning, ", Schedule L - Line 19b(b)") ,
    final2$AccountNum == 23000 ~ paste(Beginning, ", Schedule L - Line 19b(b)") ,
    final2$AccountNum == 12100 ~ paste(Beginning, ", Schedule L - Line 2a(a)") ,
    final2$AccountNum == 14100 ~ paste(Beginning, ", Schedule L - Line 6(b)") ,
    final2$AccountNum == 16100 ~ paste(Beginning, ", Schedule L - Line 6(b)") ,
    final2$AccountNum == 17000 ~ paste(Beginning, ", Schedule L - Line 9a(a)") ,  
    final2$AccountNum == 18000 ~ paste(Beginning, ", Schedule L - Line 9b(a)") ,
    final2$AccountNum == 18100 ~ paste(Beginning, ", Schedule L - Line 9b(a)") ,
    final2$AccountNum == 15100 ~ paste(Beginning, ", Schedule L - Line 8(b)") ,
    final2$AccountNum == 22100 ~ paste(Beginning, ", Schedule L - Line 17(b)") ,
    final2$AccountNum == 22200 ~ paste(Beginning, ", Schedule L - Line 17(b)") ,
    final2$AccountNum == 22300 ~ paste(Beginning, ", Schedule L - Line 17(b)") ,
    final2$AccountNum == 17001 ~ paste(Beginning, ", Schedule L - Line 9(a)") ,
    final2$AccountNum == 17002 ~ paste(Beginning, ", Schedule L - Line 9(a)") ,
    final2$AccountNum == 17003 ~ paste(Beginning, ", Schedule L - Line 9(a)") ,
    final2$AccountNum == 17004 ~ paste(Beginning, ", Schedule L - Line 9(a)") ,
    final2$AccountNum == 17005 ~ paste(Beginning, ", Schedule L - Line 9(a)") ,
    final2$AccountNum == 17006 ~ paste(Beginning, ", Schedule L - Line 9(a)") ,
    final2$AccountNum == 17007 ~ paste(Beginning, ", Schedule L - Line 9(a)") ,
    final2$AccountNum == 12500 ~ paste(Beginning, ", Schedule L - Line 2b(a)") ,
    final2$AccountNum == 41000 ~ paste(End, ", Form 1125-A - Line 6") ,
    final2$AccountNum == 51200 ~ paste(Difference, ", Schedule M-1 - Line 3") ,
    TRUE  ~ as.character(NA)))  

# Fill in for Schedule L - End
final4 <- final4 %>%
  mutate(SchLend = case_when(
    final2$AccountNum == 10100 ~ paste(End, ", Schedule L - Line 1(d)") ,
    final2$AccountNum == 19100 ~ paste(End, ", Schedule L - Line 11(d)") ,
    final2$AccountNum == 21000 ~ paste(End, ", Schedule L - Line 15(d)") ,
    final2$AccountNum == 27000 ~ paste(End, ", Schedule L - Line 21(d)") ,
    final2$AccountNum == 24000 ~ paste(End, ", Schedule L - Line 19b(d)") ,
    final2$AccountNum == 23000 ~ paste(End, ", Schedule L - Line 19b(d)") ,
    final2$AccountNum == 12100 ~ paste(End, ", Schedule L - Line 2a(c)") ,
    final2$AccountNum == 14100 ~ paste(End, ", Schedule L - Line 6(d)") ,
    final2$AccountNum == 22400 ~ paste(End, ", Schedule L - Line 16(d)") ,
    final2$AccountNum == 16100 ~ paste(End, ", Schedule L - Line 6(d)") ,
    final2$AccountNum == 17000 ~ paste(End, ", Schedule L - Line 9a(c)") ,
    final2$AccountNum == 18000 ~ paste(End, ", Schedule L - Line 9b(c)") , 
    final2$AccountNum == 18100 ~ paste(End, ", Schedule L - Line 9b(c)") , 
    final2$AccountNum == 15100 ~ paste(End, ", Schedule L - Line 8(d)") ,
    final2$AccountNum == 22100 ~ paste(End, ", Schedule L - Line 17(d)") ,
    final2$AccountNum == 17001 ~ paste(End, ", Schedule L - Line 17(c)") ,
    final2$AccountNum == 17002 ~ paste(End, ", Schedule L - Line 17(c)") ,
    final2$AccountNum == 17003 ~ paste(End, ", Schedule L - Line 17(c)") ,
    final2$AccountNum == 17004 ~ paste(End, ", Schedule L - Line 17(c)") ,
    final2$AccountNum == 17005 ~ paste(End, ", Schedule L - Line 17(c)") ,
    final2$AccountNum == 17006 ~ paste(End, ", Schedule L - Line 17(c)") ,
    final2$AccountNum == 17007 ~ paste(End, ", Schedule L - Line 17(c)") ,
    final2$AccountNum == 12500 ~ paste(End, ", Schedule L - Line 2b(c)") ,
    final2$AccountNum == 41000 ~ paste(End, ", Form 1125-A - Line 8") ,
    TRUE  ~ as.character(NA))) 

# Creating a variable for the building for depreciation 
BuildingDep <- final2 %>% 
  filter(AccountNum == 17100) %>% 
  select(End)
buildingDeprExpense <- SLN(cost = BuildingDep, salvage = 0, life = 39) #this is for the building dep expense

# Fill in for Form 8825
final4 <- final4 %>%
  mutate(form8825 = case_when(
    final2$AccountNum == 60000 ~ paste(Difference, ", Form 8825 - Line 12") ,
    final2$AccountNum == 61000 ~ paste(Difference, ", Form 8825 - Line 10") ,
    final2$AccountNum == 64000 ~ paste(Difference, ", Form 8825 - Line 11") ,
    final2$AccountNum == 62000 ~ paste(Difference, ", Form 8825 - Line 9") ,
    final2$AccountNum == 36000 ~ paste(Difference, ", Form 8825 - Line 2") ,
    final2$AccountNum == 63000 ~ paste(buildingDeprExpense, ", Form 8825 - Line 14") ,
    final2$AccountNum == 17100 ~ paste(Beginning, ", Schedule L - Line 9a(a)") , 
    TRUE  ~ as.character(NA))) 

# CREATE VARIABLES FOR CALCULATIONS

# Difference between Allowance for Doubtful Account years
allowance4doubt <- final2 %>% 
  filter(AccountNum == 12500) %>% 
  select(Difference) 

# Difference between Warenty Liability years
warrentyLiability <- final2 %>% 
  filter(AccountNum == 22200) %>% 
  select(Difference)

# Difference between unearned revenue years
unearnedRevenue <- final2 %>% 
  filter(AccountNum == 22300) %>% 
  select(Difference)

# Difference between sales revenue years
salesRevenue <- final2 %>% 
  filter(AccountNum == 31000) %>% 
  select(Difference)

# sales revenue difference plus unearned revenue difference
salesRevenue <- final2 %>% 
  filter(AccountNum == 31000) %>% 
  select(Difference) 
salesRevenue = salesRevenue[1,1] + unearnedRevenue[1,1]

# Meals difference divided by 2
meals <- final2 %>% 
  filter(AccountNum == 50700) %>% 
  select(Difference) 
meals = meals[1,1] /2

# Bad Debt difference plus Allowance for Doubtful Account difference
baddebt <- final2 %>% 
  filter(AccountNum == 50900) %>% 
  select(Difference) 
baddebt = baddebt[1,1] + allowance4doubt[1,1]

# Warrenty Expense difference plus Warrenty Liability difference
warrentyExpense <- final2 %>% 
  filter(AccountNum == 51000) %>% 
  select(Difference) 
warrentyExpense = warrentyExpense[1,1] + warrentyLiability[1,1]

# Difference between Entertainment Expenses years
entertainmentExpense <- final2 %>% 
  filter(AccountNum == 50800) %>% 
  select(Difference)

# Difference between Key-Man Life Insurance Premium years
lifeInsurance <- final2 %>% 
  filter(AccountNum == 51400) %>% 
  select(Difference)

# Difference between parking fine Premium years
parkingfine <- final2 %>% 
  filter(AccountNum == 50400) %>% 
  select(Difference)

# create NonDeductible Expense amount
nondeductibleExpenses <- (meals + lifeInsurance + entertainmentExpense )

# Create variables for the calculation in Schedule K Line 2
RentRevenue <- final2 %>% 
  filter(AccountNum == 36000) %>% 
  select(Difference)

BUildUtilities <- final2 %>% 
  filter(AccountNum == 60000) %>% 
  select(Difference)

BuildMaint <- final2 %>% 
  filter(AccountNum == 61000) %>% 
  select(Difference)

BuildInterestExp <- final2 %>% 
  filter(AccountNum == 62000) %>% 
  select(Difference)

BuildPropertyTaxes <- final2 %>% 
  filter(AccountNum == 64000) %>% 
  select(Difference)

# Final Calculation for Schedule K Line 2 
RentalIncomeLoss = (RentRevenue + BUildUtilities + BuildMaint + BuildInterestExp + BuildPropertyTaxes + buildingDeprExpense) * -1

# Create variables for calculation for Schedule L Line 9 (Beginning and End columns)
bonus <- final2 %>% 
  filter(AccountNum == 17000) %>% 
  select(Beginning, End)

Build <- final2 %>% 
  filter(AccountNum == 17100) %>% 
  select(Beginning, End)

EquipDep <- final2 %>% 
  filter(AccountNum == 18000) %>% 
  select(Beginning, End)

BuildDep <- final2 %>% 
  filter(AccountNum == 18100) %>% 
  select(Beginning, End)

three <- final2 %>% 
  filter(AccountNum == 17002) %>% 
  select(Beginning, End)

five <- final2 %>% 
  filter(AccountNum == 17003) %>% 
  select(Beginning, End)

seven <- final2 %>% 
  filter(AccountNum == 17004) %>% 
  select(Beginning, End)

fifteen <- final2 %>% 
  filter(AccountNum == 17005) %>% 
  select(Beginning, End)

twentyseven <- final2 %>% 
  filter(AccountNum == 17006) %>% 
  select(Beginning, End)

thirtynine <- final2 %>% 
  filter(AccountNum == 17007) %>% 
  select(Beginning, End)

oneseventynine <- final2 %>% 
  filter(AccountNum == 17001) %>% 
  select(Beginning, End)

# Final calculation for Schedule L Line 9b column b Beginning
ninebb = bonus[1,1] + Build[1,1] + EquipDep[1,1] + BuildDep[1,1] + three[1,1] + five[1,1] + seven[1,1] + fifteen[1,1] + twentyseven[1,1] + thirtynine[1,1] + oneseventynine[1,1]

# Final Calculation for Schedule L Line 9b column d End
ninebd = bonus[1,2] + Build[1,2] + EquipDep[1,2] + BuildDep[1,2] + three[1,2] + five[1,2] + seven[1,2] + fifteen[1,2] + twentyseven[1,2] + thirtynine[1,2] + oneseventynine[1,2]




# Final Calculation for Schedule L Line 2b
twoa <- final2 %>% 
  filter(AccountNum == 12100) %>% 
  select(Beginning, End)
twoa$Beginning <- abs( twoa$Beginning)
twoa$End <- abs( twoa$End)

twob <- final2 %>% 
  filter(AccountNum == 12500) %>% 
  select(Beginning, End)
twob = (twob * -1)
twob$Beginning <- abs( twob$Beginning)
twob$End <- abs( twob$End)

twobb = twoa[1,1] - twob[1,1]
twobd = twoa[1,2] - twob[1,2]



# Create calculations for different depreciations for Form 1065 Line 16a
DepreciationExpense <- final2 %>% 
  filter(AccountNum == 50600) %>% 
  select(End)

# 100% Bonus Depreciation varible
OneHundredBonus <- final2 %>% 
  filter(AccountNum == 17000) %>% 
  select(Beginning, End)
OneHundredBonusDep = OneHundredBonus[1,1] - OneHundredBonus[1,2] + (DepreciationExpense[1,1]*-1) + DepreciationExpense[1,1]

# 3 Year Depreciation
threeYear <- final2 %>% 
  filter(AccountNum == 17002) %>% 
  select(End)
threeYear <- SLN(cost = threeYear, salvage = 0, life = 3)

# 5 Year Depreciation
fiveYear <- final2 %>% 
  filter(AccountNum == 17003) %>% 
  select(End)
fiveYear <- SLN(cost = fiveYear, salvage = 0, life = 5)

# 7 Year Depreciation
sevenYear <- final2 %>% 
  filter(AccountNum == 17004) %>% 
  select(End)
sevenYear <- SLN(cost = sevenYear, salvage = 0, life = 7)

# 15 Year Depreciation
fifteenYear <- final2 %>% 
  filter(AccountNum == 17005) %>% 
  select(End)
fifteenYear <- SLN(cost = fifteenYear, salvage = 0, life = 15)

# 27.5 Year Depreciation
TwentySevenFiveYear <- final2 %>% 
  filter(AccountNum == 17006) %>% 
  select(End)
TwentySevenFiveYear <- SLN(cost = TwentySevenFiveYear, salvage = 0, life = 27.5)

# 39 Year Depreciation
thirtyNineYear <- final2 %>% 
  filter(AccountNum == 17007) %>% 
  select(End)
thirtyNineYear <- SLN(cost = thirtyNineYear, salvage = 0, life = 39)

# Section 179 Depreciation
OneSeventyNineYear <- final2 %>% 
  filter(AccountNum == 17001) %>% 
  select(Beginning, End)
OneSeventyNineYear = OneSeventyNineYear[1,1] - OneSeventyNineYear[1,2] + (DepreciationExpense[1,1]*-1) + DepreciationExpense[1,1]

# Make Depreciation Expense calc
DepreciationExp = OneHundredBonusDep[1,1] + threeYear[1,1] + fiveYear[1,1] + sevenYear[1,1] + fifteenYear[1,1] + TwentySevenFiveYear[1,1] + thirtyNineYear[1,1] + OneSeventyNineYear[1,1] 


# Make calculation for Ordinary Income
salesRevenue <- final2 %>% 
  filter(AccountNum == 31000) %>% 
  select(Difference) 
salesRevenuePos = ( (salesRevenue[1,1]*-1) + (unearnedRevenue[1,1] * -1))

ParkingFineExpense = parkingfine[1,1] *-1

COGS <- final2 %>% 
  filter(AccountNum == 41000) %>% 
  select(Difference)
COGS = COGS[1,1] * -1

SalariesWageExpense <- final2 %>% 
  filter(AccountNum == 50000) %>% 
  select(Difference) 
SalariesWageExpense = SalariesWageExpense[1,1] * -1

SuppliesExpense <- final2 %>% 
  filter(AccountNum == 50100) %>% 
  select(Difference) 
SuppliesExpense = SuppliesExpense[1,1] * -1

RentExpense <- final2 %>% 
  filter(AccountNum == 50300) %>% 
  select(Difference)
RentExpense = RentExpense[1,1] * -1

InsuranceExpense <- final2 %>% 
  filter(AccountNum == 50500) %>% 
  select(Difference) 
InsuranceExpense = InsuranceExpense[1,1] * -1

UtilitiesExpense <- final2 %>% 
  filter(AccountNum == 51100) %>% 
  select(Difference) 
UtilitiesExpense = UtilitiesExpense[1,1] * -1

GuaranteedExpense <- final2 %>% 
  filter(AccountNum == 51200) %>% 
  select(Difference)  
GuaranteedExpense = GuaranteedExpense[1,1] * -1

PayrollExpense <- final2 %>% 
  filter(AccountNum == 51300) %>% 
  select(Difference)
PayrollExpense = PayrollExpense[1,1] * -1

InterestExpense <- final2 %>% 
  filter(AccountNum == 51500) %>% 
  select(Difference) 
InterestExpense = InterestExpense[1,1] * -1

BadDebtExpense = baddebt[1,1] *-1
MealsExpense = meals[1,1] *-1


warrentyL <- final2 %>% 
  filter(AccountNum == 22200) %>% 
  select(Beginning, End)
warrentyL = warrentyL[1,1] - warrentyL[1,2] 

WarrentyE <- final2 %>% 
  filter(AccountNum == 51000) %>% 
  select(Difference) 
WarrentyE = WarrentyE * -1

newWarrenty = warrentyL + WarrentyE

OrdinaryIncome = salesRevenuePos + COGS[1,1] + SalariesWageExpense[1,1] + SuppliesExpense[1,1] + RentExpense[1,1] + InsuranceExpense[1,1] + DepreciationExp + MealsExpense + BadDebtExpense + newWarrenty + UtilitiesExpense[1,1] + GuaranteedExpense[1,1] + PayrollExpense[1,1] + InterestExpense[1,1]      




InterestIncome <- final2 %>% 
  filter(AccountNum == 32000) %>% 
  select(Difference) 
InterestIncome = InterestIncome * -1

DividendIncome <- final2 %>% 
  filter(AccountNum == 33000) %>% 
  select(Difference) 
DividendIncome = DividendIncome * -1

longTerm <- final2 %>% 
  filter(AccountNum == 34000) %>% 
  select(End) 
longTerm = longTerm * -1

shortTerm <- final2 %>% 
  filter(AccountNum == 34001) %>% 
  select(End) 
shortTerm = shortTerm * -1

CharitableContributions <- final2 %>% 
  filter(AccountNum == 50200) %>% 
  select(Difference) 

TotalBookIncome = OrdinaryIncome + RentalIncomeLoss + InterestIncome + DividendIncome + longTerm + shortTerm - CharitableContributions

oneAandC <- abs(salesRevenue + unearnedRevenue)
GrossProfit = oneAandC - abs(COGS)

TotalIncome = GrossProfit 

TotalDeductions = abs(SalariesWageExpense ) + abs(GuaranteedExpense) + baddebt + abs(RentExpense) + abs(InterestExpense) + abs(DepreciationExp) + abs(SuppliesExpense) + abs(InsuranceExpense) + abs(UtilitiesExpense) + abs(PayrollExpense) + (warrentyExpense ) + abs(MealsExpense)

OrdinaryBusIncome = (TotalIncome - TotalDeductions)





# Make row for Sch L line 14 B total assets Begininng 
oneB <- final2 %>% 
  filter(AccountNum == 10100) %>% 
  select(Beginning) 
oneB = abs(oneB[1,1] )

sixB1 <- final2 %>%                    
  filter(AccountNum == 14100) %>% 
  select(Beginning) 
sixB2 <- final2 %>%                    
  filter(AccountNum == 16100) %>% 
  select(Beginning) 
sixB = ( abs(sixB1[1,1] ) + abs(sixB2[1,1])  )

eightB1 <- final2 %>%  
  filter(AccountNum == 15100) %>% 
  select(Beginning) 
eightB =  abs(eightB1[1,1]) 

nineB = ninebb

elevenB <- final2 %>% 
  filter(AccountNum == 19100) %>% 
  select(Beginning) 
elevenB = abs(elevenB[1,1] )

TotalAssetsB = oneB + twobb + sixB + eightB + nineB + elevenB


# Make row for Sch L line 14 D total assets End
oneD <- final2 %>% 
  filter(AccountNum == 10100) %>% 
  select(End) 
oneD = abs(oneD[1,1])

sixD1 <- final2 %>%                    
  filter(AccountNum == 14100) %>% 
  select(End) 
sixD2 <- final2 %>%                    
  filter(AccountNum == 16100) %>% 
  select(End) 
sixD = ( abs(sixD1[1,1] ) + abs(sixD2[1,1] )  )

eightD1 <- final2 %>%  
  filter(AccountNum == 15100) %>% 
  select(End) 
eightD = abs(eightD1[1,1] ) 

nineD = ninebd

elevenD <- final2 %>% 
  filter(AccountNum == 19100) %>% 
  select(End) 
elevenD = abs( elevenD[1,1] )

TotalAssetsD = oneD + twobd + sixD + eightD + nineD + elevenD
  
 
  
  
  
  
  
   
# Make row for Sch L line 22 B total liabilites Begininng 
fifteenB <- final2 %>% 
filter(AccountNum == 21000) %>% 
select(Beginning) 
fifteenB = fifteenB[1,1] * -1

sixteenB <- final2 %>% 
  filter(AccountNum == 22400) %>% 
  select(Beginning) 
sixteenB = sixteenB[1,1] * -1

seventeenB1 <- final2 %>%                    
  filter(AccountNum == 22100) %>% 
  select(Beginning) 
seventeenB2 <- final2 %>%                    
  filter(AccountNum == 22200) %>% 
  select(Beginning) 
seventeenB3 <- final2 %>%                    
  filter(AccountNum == 22300) %>% 
  select(Beginning) 
seventeenB4 <- final2 %>%                    
  filter(AccountNum == 17001) %>% 
  select(Beginning) 
seventeenB5 <- final2 %>%                    
  filter(AccountNum == 17002) %>% 
  select(Beginning) 
seventeenB6 <- final2 %>%                    
  filter(AccountNum == 17003) %>% 
  select(Beginning) 
seventeenB7 <- final2 %>%                    
  filter(AccountNum == 17004) %>% 
  select(Beginning) 
seventeenB8 <- final2 %>%                    
  filter(AccountNum == 17005) %>% 
  select(Beginning) 
seventeenB9 <- final2 %>%                    
  filter(AccountNum == 17006) %>% 
  select(Beginning) 
seventeenB10 <- final2 %>%                    
  filter(AccountNum == 17007) %>% 
  select(Beginning) 
seventeenB = ( (seventeenB1[1,1] * -1) + (seventeenB2[1,1] * -1) + (seventeenB3[1,1] * -1) + (seventeenB4[1,1] * -1) + (seventeenB5[1,1] * -1) + (seventeenB6[1,1] * -1) + (seventeenB7[1,1] * -1) + (seventeenB8[1,1] * -1) + (seventeenB9[1,1] * -1) + (seventeenB10[1,1] * -1) )

nineteenB1 <- final2 %>% 
  filter(AccountNum == 23000) %>% 
  select(Beginning) 
nineteenB2 <- final2 %>% 
  filter(AccountNum == 24000) %>% 
  select(Beginning) 
nineteenB = ((nineteenB1[1,1] * -1) + (nineteenB2[1,1] * -1))

twentyoneB <- final2 %>% 
  filter(AccountNum == 27000) %>% 
  select(Beginning) 
twentyoneB = twentyoneB[1,1] * -1

TotalLiabilitiesB = fifteenB + sixteenB + seventeenB + nineteenB + twentyoneB 


# Make row for Sch L line 22 D total liabilites END
fifteenD <- final2 %>% 
  filter(AccountNum == 21000) %>% 
  select(End) 
fifteenD = fifteenD[1,1] * -1

sixteenD <- final2 %>% 
  filter(AccountNum == 22400) %>% 
  select(End) 
sixteenD = sixteenD[1,1] * -1

seventeenD1 <- final2 %>%                    
  filter(AccountNum == 22100) %>% 
  select(End) 
seventeenD2 <- final2 %>%                    
  filter(AccountNum == 22200) %>% 
  select(End) 
seventeenD3 <- final2 %>%                    
  filter(AccountNum == 22300) %>% 
  select(End) 
seventeenD4 <- final2 %>%                    
  filter(AccountNum == 17001) %>% 
  select(End) 
seventeenD5 <- final2 %>%                    
  filter(AccountNum == 17002) %>% 
  select(End) 
seventeenD6 <- final2 %>%                    
  filter(AccountNum == 17003) %>% 
  select(End) 
seventeenD7 <- final2 %>%                    
  filter(AccountNum == 17004) %>% 
  select(End) 
seventeenD8 <- final2 %>%                    
  filter(AccountNum == 17005) %>% 
  select(End) 
seventeenD9 <- final2 %>%                    
  filter(AccountNum == 17006) %>% 
  select(End) 
seventeenD10 <- final2 %>%                    
  filter(AccountNum == 17007) %>% 
  select(End) 
seventeenD = ( (seventeenD1[1,1] * -1) + (seventeenD2[1,1] * -1) + (seventeenD3[1,1] * -1) + (seventeenD4[1,1] * -1) + (seventeenD5[1,1] * -1) + (seventeenD6[1,1] * -1) + (seventeenD7[1,1] * -1) + (seventeenD8[1,1] * -1) + (seventeenD9[1,1] * -1) + (seventeenD10[1,1] * -1) )

nineteenD1 <- final2 %>% 
  filter(AccountNum == 23000) %>% 
  select(End) 
nineteenD2 <- final2 %>% 
  filter(AccountNum == 24000) %>% 
  select(End) 
nineteenD = ((nineteenD1[1,1] * -1) + (nineteenD2[1,1] * -1))

twentyoneD <- final2 %>% 
  filter(AccountNum == 27000) %>% 
  select(End) 
twentyoneD = twentyoneD[1,1] * -1

TotalLiabilitiesD = fifteenD + sixteenD + seventeenD + nineteenD + twentyoneD



fourB <- abs(MealsExpense) + entertainmentExpense

m1five <- fourB + abs(GuaranteedExpense) + TotalBookIncome

oneAandC <- abs(salesRevenue + unearnedRevenue)
  
# Fill in for sections that require calculations (taken from above)
final4 <- final4 %>%
  mutate(calcs = case_when(
    final2$AccountNum == 50700 ~ paste(meals, ", Form 1065 - Line 20") ,
    final2$AccountNum == 50900 ~ paste(baddebt, ", Form 1065 - Line 12") ,
    final2$AccountNum == 22200 ~ paste(warrentyExpense, ", Form 1065 - Line 20") ,
    final2$AccountNum == 31000 ~ paste(oneAandC, ", Form 1065 - Line 1a/1c") ,
    final2$AccountNum == 50400 ~ paste("-", ",NonDeductible Expense") ,
    final2$AccountNum == 50800 ~ paste("-", ",NonDeductible Expense") ,
    final2$AccountNum == 51400 ~ paste("-", ",NonDeductible Expense") ,
    final2$AccountNum == 50600 ~ paste(DepreciationExp, ", Form 1065 - Line 16a") ,
    TRUE  ~ as.character(NA))) 

# Gather columns, remove duplicates, separate main colum into 2
finalform <- final4 %>% 
  gather(c(6:11),key = "round", value = "stuff", -AccountNum) %>% 
  select(-round) %>% 
  distinct(AccountNum, stuff, .keep_all= TRUE) %>% 
  separate(stuff, into = c("TaxAmount", "TaxLine"), sep = ",") %>% 
  add_row(AccountNum = "-", AccountName = "Nondeductible Expenses", Beginning = "-", End = "-", Difference = "-",  TaxAmount = nondeductibleExpenses, TaxLine = " Schedule K - Line 18c") %>% #add non deduction row 
  add_row(AccountNum = "-", AccountName = "Beginning Net Buildings and other depreciable assets", Beginning = "-", End = "-", Difference = "-",  TaxAmount = ninebb, TaxLine = " Schedule L - Line 9b(b)") %>%  #add Sch L 9b col b row for calc beginngin 
  add_row(AccountNum = "-", AccountName = "End Net Buildings and other depreciable assets", Beginning = "-", End = "-", Difference = "-",  TaxAmount = ninebd, TaxLine = " Schedule L - Line 9b(d)") %>% #add Sch L 9b col d row for calc  end 
  add_row(AccountNum = "-", AccountName = "Rent Income/(Loss)", Beginning = "-", End = "-", Difference = "-",  TaxAmount = RentalIncomeLoss, TaxLine = " Schedule K - Line 2") %>% #add Sch L 9b col d row for calc  end 
  add_row(AccountNum = "-", AccountName = "Ordinary Income", Beginning = "-", End = "-", Difference = "-",  TaxAmount = OrdinaryIncome, TaxLine = " Schedule K - Line 1") %>% #add Ordinary Income row
  add_row(AccountNum = "-", AccountName = "Total Book Income", Beginning = "-", End = "-", Difference = "-",  TaxAmount = TotalBookIncome, TaxLine = " Schedule M-1 - Line 1") %>% #add Ordinary Income row
  add_row(AccountNum = "-", AccountName = "Gross Profit", Beginning = "-", End = "-", Difference = "-",  TaxAmount = GrossProfit , TaxLine = " Form 1065 - Line 3") %>% #add Gross Profit row
  add_row(AccountNum = "-", AccountName = "Total Income (Loss)", Beginning = "-", End = "-", Difference = "-",  TaxAmount = TotalIncome , TaxLine = " Form 1065 - Line 8") %>% #add Total Income row
  add_row(AccountNum = "-", AccountName = "Total Deductions", Beginning = "-", End = "-", Difference = "-",  TaxAmount = TotalDeductions , TaxLine = " Form 1065 - Line 21") %>% #add Total Deductions row
  add_row(AccountNum = "-", AccountName = "Ordinary Business Income (Loss)", Beginning = "-", End = "-", Difference = "-",  TaxAmount = OrdinaryBusIncome , TaxLine = " Form 1065 - Line 22") %>% #add Total Income row
  add_row(AccountNum = "-", AccountName = "Beginnging Less Allowance for Bad Debts", Beginning = "-", End = "-", Difference = "-",  TaxAmount = twobb, TaxLine = " Schedule L - Line 2b(b)") %>%  #add Sch L 2b col b row for calc beginngin 
  add_row(AccountNum = "-", AccountName = "End Less Allowance for Bad Debts", Beginning = "-", End = "-", Difference = "-",  TaxAmount = twobd, TaxLine = " Schedule L - Line 2b(d)") %>% #add Sch L 2b col d row for calc  end 
  add_row(AccountNum = "-", AccountName = "Total Assets B", Beginning = "-", End = "-", Difference = "-",  TaxAmount = TotalAssetsB , TaxLine = " Schedule L - Line 14(b)") %>% #add Total Assets row
  add_row(AccountNum = "-", AccountName = "Total Assets D", Beginning = "-", End = "-", Difference = "-",  TaxAmount = TotalAssetsD , TaxLine = " Schedule L - Line 14(d)") %>% #add Total Assets row
  add_row(AccountNum = "-", AccountName = "Total Liabilities and Capital B", Beginning = "-", End = "-", Difference = "-",  TaxAmount = TotalLiabilitiesB , TaxLine = " Schedule L - Line 22(b)") %>% #add Total Liabilities and Capital row
  add_row(AccountNum = "-", AccountName = "Total Liabilities and Capital D", Beginning = "-", End = "-", Difference = "-",  TaxAmount = TotalLiabilitiesD , TaxLine = " Schedule L - Line 22(d)") %>% #add Total Liabilities and Capital row
  
  add_row(AccountNum = "-", AccountName = "Travel & Entertainment", Beginning = "-", End = "-", Difference = "-",  TaxAmount = fourB , TaxLine = " Schedule M-1 - Line 4(b)") %>% #add Total Liabilities and Capital row
  add_row(AccountNum = "-", AccountName = "-", Beginning = "-", End = "-", Difference = "-",  TaxAmount = m1five , TaxLine = " Schedule M-1 - Line 5") %>% #add Total Liabilities and Capital row
  
  
  drop_na(TaxLine)  %>% 
  filter(TaxAmount != 0)

# Change "TaxAmount" column into numerical values
finalform$TaxAmount <- as.numeric(finalform$TaxAmount)
finalform$TaxAmount <- abs( finalform$TaxAmount)


finalform$AccountNum <- as.numeric(finalform$AccountNum)
finalform$Beginning <- as.numeric(finalform$Beginning)
finalform$End <- as.numeric(finalform$End)
finalform$Difference <- as.numeric(finalform$Difference)


round_df <- function(df, digits) {
  nums <- vapply(df, is.numeric, FUN.VALUE = logical(1))
  df[,nums] <- round(df[,nums], digits = digits)
  (df)
}

finalform <- round_df(finalform, digits=0) 
finalform$TaxAmount <- abs( finalform$TaxAmount)
 


# Write the new file to your folder - called UpdatedTest.xlsx
write_xlsx(finalform, path = here::here("UpdatedTest.xlsx"))




#### end ####



#### Write PDF File ####


try <- finalform %>%
  select(TaxLine, TaxAmount) %>% 
  group_by(TaxLine) %>% 
  summarise(Total = sum(TaxAmount))

try <- try[order(try$TaxLine),]




#library(fs)

#pdf_files <- dir_ls("pdfs/")

#devtools::install_github("pridiltal/staplr")

##put F1065, F8825 and K1 all into one PDF
#staplr::staple_pdf(input_files = pdf_files, output_filepath = "TaxPacket.pdf")

##remove instruaction pages
#staplr::remove_pages(rmpages = c(7, 8, 11, 13) , input_filepath = "TaxPacket.pdf", output_filepath = "BestTaxPacket.pdf")

## If you get path to this file by
#pdfFile = system.file('TaxPacket.pdf',package = 'staplr')





# Get fields
fields = staplr::get_fields("BestTaxPacket.pdf")





# Forn 1065
fields$`topmostSubform[0].Page1[0].f1_15[0]`$value = try[(try$TaxLine == " Form 1065 - Line 1a/1c"), 2] # 1065 line 1a   NO
fields$`topmostSubform[0].Page1[0].f1_17[0]`$value = try[(try$TaxLine == " Form 1065 - Line 1a/1c"), 2] # 1065 line 1c   NO
fields$`topmostSubform[0].Page1[0].f1_18[0]`$value = try[(try$TaxLine == " Form 1065 - Line 2"), 2] # 1065 line 2   
fields$`topmostSubform[0].Page1[0].f1_20[0]`$value = try[(try$TaxLine == " Form 1065 - Line 3"), 2] # 1065 line 3  

fields$`topmostSubform[0].Page1[0].f1_24[0]`$value = try[(try$TaxLine == " Form 1065 - Line 8"), 2]  # 1065 line 8  YES
fields$`topmostSubform[0].Page1[0].f1_25[0]`$value = try[(try$TaxLine == " Form 1065 - Line 9"), 2] # 1065 line 9    NO
fields$`topmostSubform[0].Page1[0].f1_26[0]`$value = try[(try$TaxLine == " Form 1065 - Line 10"), 2] # 1065 line 10  NO
fields$`topmostSubform[0].Page1[0].f1_28[0]`$value = try[(try$TaxLine == " Form 1065 - Line 12"), 2] # 1065 line 12 NO
fields$`topmostSubform[0].Page1[0].f1_29[0]`$value = try[(try$TaxLine == " Form 1065 - Line 13"), 2] # 1065 line 13 NO
fields$`topmostSubform[0].Page1[0].f1_31[0]`$value = try[(try$TaxLine == " Form 1065 - Line 15"), 2] # 1065 line 15 
fields$`topmostSubform[0].Page1[0].f1_32[0]`$value = try[(try$TaxLine == " Form 1065 - Line 16a"), 2] # 1065 line 16a
fields$`topmostSubform[0].Page1[0].f1_38[0]`$value = try[(try$TaxLine == " Form 1065 - Line 20"), 2] # 1065 line 20
fields$`topmostSubform[0].Page1[0].f1_39[0]`$value = try[(try$TaxLine == " Form 1065 - Line 21"), 2] # 1065 line 21
fields$`topmostSubform[0].Page1[0].f1_40[0]`$value = try[(try$TaxLine == " Form 1065 - Line 22"), 2] # 1065 line 22


# Form 8825
fields$`topmostSubform[0].Page1[0].Table_Lines2-17[0].Line2[0].#subform[0].f1_35[0]`$value = try[(try$TaxLine == " Form 8825 - Line 2"), 2] # 8825 line 2
fields$`topmostSubform[0].Page1[0].Table_Lines2-17[0].Line9[0].#subform[0].f1_91[0]`$value = try[(try$TaxLine == " Form 8825 - Line 9"), 2] # 8825 line 9
fields$`topmostSubform[0].Page1[0].Table_Lines2-17[0].Line10[0].#subform[0].f1_99[0]`$value = try[(try$TaxLine == " Form 8825 - Line 10"), 2] # 8825 line 10 a
fields$`topmostSubform[0].Page1[0].Table_Lines2-17[0].Line11[0].#subform[0].f1_107[0]`$value = try[(try$TaxLine == " Form 8825 - Line 11"), 2] # 8825 line 11
fields$`topmostSubform[0].Page1[0].Table_Lines2-17[0].Line12[0].#subform[0].f1_115[0]`$value = try[(try$TaxLine == " Form 8825 - Line 12"), 2] # 8825 line 12
fields$`topmostSubform[0].Page1[0].Table_Lines2-17[0].Line14[0].#subform[0].f1_131[0]`$value = try[(try$TaxLine == " Form 8825 - Line 14"), 2] # 8825 line 14

# Schedule K
fields$`topmostSubform[0].Page4[0].f4_01[0]`$value = try[(try$TaxLine == " Schedule K - Line 1"), 2] # Sch K line 1
fields$`topmostSubform[0].Page4[0].f4_02[0]`$value = try[(try$TaxLine == " Schedule K - Line 2"), 2] # Sch K line 2
fields$`topmostSubform[0].Page4[0].f4_08[0]`$value = try[(try$TaxLine == " Schedule K - Line 4"), 2] # Sch K line 4
fields$`topmostSubform[0].Page4[0].f4_09[0]`$value = try[(try$TaxLine == " Schedule K - Line 5"), 2] # Sch K line 5
fields$`topmostSubform[0].Page4[0].f4_10[0]`$value = try[(try$TaxLine == " Schedule K - Line 6"), 2] # Sch K line 6
fields$`topmostSubform[0].Page4[0].f4_11[0]`$value = try[(try$TaxLine == " Schedule K - Line 6"), 2] # Sch K line 6
fields$`topmostSubform[0].Page4[0].f4_15[0]`$value = try[(try$TaxLine == " Schedule K - Line 9a"), 2] # Sch K line 9a
fields$`topmostSubform[0].Page4[0].f4_22[0]`$value = try[(try$TaxLine == " Schedule K - Line 13a"), 2] # Sch K line 13a
fields$`topmostSubform[0].Page4[0].f4_65[0]`$value = try[(try$TaxLine == " Schedule K - Line 18c"), 2] # Sch K line 18c

# Schedule M1
fields$`topmostSubform[0].Page5[0].SchM-1_Left[0].f5_126[0]`$value = try[(try$TaxLine == " Schedule M-1 - Line 1"), 2] # Sch M1 line 1


fields$`topmostSubform[0].Page5[0].SchM-1_Left[0].f5_129[0]`$value = try[(try$TaxLine == " Schedule M-1 - Line 3"), 2] # Sch M1 line 1
fields$`topmostSubform[0].Page5[0].SchM-1_Left[0].f5_131[0]`$value = try[(try$TaxLine == " Schedule M-1 - Line 4(b)"), 2] # Sch M1 line 1
fields$`topmostSubform[0].Page5[0].SchM-1_Left[0].f5_132[0]`$value = try[(try$TaxLine == " Schedule M-1 - Line 4(b)"), 2] # Sch M1 line 1
fields$`topmostSubform[0].Page5[0].SchM-1_Left[0].f5_133[0]`$value = try[(try$TaxLine == " Schedule M-1 - Line 5"), 2] # Sch M1 line 1



# Form 1125 - A COGS   NOT WORKING
#fields$`topmostSubform[0].Page1[0].f1_01[0]`$value = try[10,2] # Form 1125a line 2
#fields$`topmostSubform[0].Page5[0].Table_Assets[0].Line1[0].f5_15[0]`$value = try[11,2] # Form 1125a line 6
#fields$`topmostSubform[0].Page5[0].Table_Assets[0].Line1[0].f5_15[0]`$value = try[12,2] # Form 1125a line 8


# Schedule L
fields$`topmostSubform[0].Page5[0].Table_Assets[0].Line1[0].f5_15[0]`$value = try[(try$TaxLine == " Schedule L - Line 1(b)"), 2] # Sch L line 1b
fields$`topmostSubform[0].Page5[0].Table_Assets[0].Line1[0].f5_17[0]`$value = try[(try$TaxLine == " Schedule L - Line 1(d)"), 2] # Sch L line 1d
fields$`topmostSubform[0].Page5[0].Table_Assets[0].Line2a[0].f5_18[0]`$value = try[(try$TaxLine == " Schedule L - Line 2a(a)"), 2] # Sch L line 2aa
fields$`topmostSubform[0].Page5[0].Table_Assets[0].Line2a[0].f5_20[0]`$value = try[(try$TaxLine == " Schedule L - Line 2a(c)"), 2] # Sch L line 2ac
fields$`topmostSubform[0].Page5[0].Table_Assets[0].Line2b[0].f5_22[0]`$value = try[(try$TaxLine == " Schedule L - Line 2b(a)"), 2] # Sch L line 2ba
fields$`topmostSubform[0].Page5[0].Table_Assets[0].Line2b[0].f5_23[0]`$value = try[(try$TaxLine == " Schedule L - Line 2b(b)"), 2] # Sch L line 2bb
fields$`topmostSubform[0].Page5[0].Table_Assets[0].Line2b[0].f5_24[0]`$value = try[(try$TaxLine == " Schedule L - Line 2b(c)"), 2] # Sch L line 2bc
fields$`topmostSubform[0].Page5[0].Table_Assets[0].Line2b[0].f5_25[0]`$value = try[(try$TaxLine == " Schedule L - Line 2b(d)"), 2] # Sch L line 2bd
fields$`topmostSubform[0].Page5[0].Table_Assets[0].Line6[0].f5_39[0]`$value = try[(try$TaxLine == " Schedule L - Line 6(b)"), 2] # Sch L line 6b
fields$`topmostSubform[0].Page5[0].Table_Assets[0].Line6[0].f5_41[0]`$value = try[(try$TaxLine == " Schedule L - Line 6(d)"), 2] # Sch L line 6d
fields$`topmostSubform[0].Page5[0].Table_Assets[0].Line8[0].f5_51[0]`$value = try[(try$TaxLine == " Schedule L - Line 8(b)"), 2] # Sch L line 8b
fields$`topmostSubform[0].Page5[0].Table_Assets[0].Line8[0].f5_53[0]`$value = try[(try$TaxLine == " Schedule L - Line 8(d)"), 2] # Sch L line 8d
fields$`topmostSubform[0].Page5[0].Table_Assets[0].Line9a[0].f5_54[0]`$value = try[(try$TaxLine == " Schedule L - Line 9a(a)"), 2] # Sch L line 9aa
fields$`topmostSubform[0].Page5[0].Table_Assets[0].Line9a[0].f5_56[0]`$value = try[(try$TaxLine == " Schedule L - Line 9a(c)"), 2] # Sch L line 9ac 
fields$`topmostSubform[0].Page5[0].Table_Assets[0].Line9b[0].f5_58[0]`$value = try[(try$TaxLine == " Schedule L - Line 9b(a)"), 2] # Sch L line 9ba
fields$`topmostSubform[0].Page5[0].Table_Assets[0].Line9b[0].f5_60[0]`$value = try[(try$TaxLine == " Schedule L - Line 9b(c)"), 2] # Sch L line 9bc
fields$`topmostSubform[0].Page5[0].Table_Assets[0].Line9b[0].f5_59[0]`$value = try[(try$TaxLine == " Schedule L - Line 9b(b)"), 2] # Sch L line 9bb
fields$`topmostSubform[0].Page5[0].Table_Assets[0].Line9b[0].f5_61[0]`$value = try[(try$TaxLine == " Schedule L - Line 9b(d)"), 2] # Sch L line 9bd
fields$`topmostSubform[0].Page5[0].Table_Assets[0].Line11[0].f5_71[0]`$value = try[(try$TaxLine == " Schedule L - Line 11(b)"), 2] # Sch L line 11b
fields$`topmostSubform[0].Page5[0].Table_Assets[0].Line11[0].f5_73[0]`$value = try[(try$TaxLine == " Schedule L - Line 11(d)"), 2] # Sch L line 11d
fields$`topmostSubform[0].Page5[0].Table_Assets[0].Line14[0].f5_87[0]`$value = try[(try$TaxLine == " Schedule L - Line 14(b)"), 2] # Sch L line 14b
fields$`topmostSubform[0].Page5[0].Table_Assets[0].Line14[0].f5_89[0]`$value = try[(try$TaxLine == " Schedule L - Line 14(d)"), 2] # Sch L line 14d
fields$`topmostSubform[0].Page5[0].Table_Liabilities[0].Line15[0].f5_91[0]`$value = try[(try$TaxLine == " Schedule L - Line 15(b)"), 2] # Sch L line 15b
fields$`topmostSubform[0].Page5[0].Table_Liabilities[0].Line15[0].f5_93[0]`$value = try[(try$TaxLine == " Schedule L - Line 15(d)"), 2] # Sch L line 15d
fields$`topmostSubform[0].Page5[0].Table_Liabilities[0].Line16[0].f5_97[0]`$value = try[(try$TaxLine == " Schedule L - Line 16(d)"), 2] # Sch L line 16d
fields$`topmostSubform[0].Page5[0].Table_Liabilities[0].Line17[0].f5_99[0]`$value = try[(try$TaxLine == " Schedule L - Line 17(b)"), 2] # Sch L line 17b
fields$`topmostSubform[0].Page5[0].Table_Liabilities[0].Line17[0].f5_101[0]`$value = try[(try$TaxLine == " Schedule L - Line 17(d)"), 2] # Sch L line 17d
fields$`topmostSubform[0].Page5[0].Table_Liabilities[0].Line19b[0].f5_111[0]`$value = try[(try$TaxLine == " Schedule L - Line 19b(b)"), 2] # Sch L line 19bb
fields$`topmostSubform[0].Page5[0].Table_Liabilities[0].Line19b[0].f5_113[0]`$value = try[(try$TaxLine == " Schedule L - Line 19b(d)"), 2] # Sch L line 19bd
fields$`topmostSubform[0].Page5[0].Table_Liabilities[0].Line21[0].f5_119[0]`$value = try[(try$TaxLine == " Schedule L - Line 21(b)"), 2] # Sch L line 21b
fields$`topmostSubform[0].Page5[0].Table_Liabilities[0].Line21[0].f5_121[0]`$value = try[(try$TaxLine == " Schedule L - Line 21(d)"), 2] # Sch L line 21d
fields$`topmostSubform[0].Page5[0].Table_Liabilities[0].Line22[0].f5_123[0]`$value = try[(try$TaxLine == " Schedule L - Line 22(b)"), 2] # Sch L line 22b
fields$`topmostSubform[0].Page5[0].Table_Liabilities[0].Line22[0].f5_125[0]`$value = try[(try$TaxLine == " Schedule L - Line 22(d)"), 2] # Sch L line 22d

staplr::set_fields("BestTaxPacket.pdf", 'UpdatedTaxPacket.pdf', fields)


#### end ####

