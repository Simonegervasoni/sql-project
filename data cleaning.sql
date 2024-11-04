-- standardize date format
Select SaleDateConverted, CONVERT(Date, SaleDate)
From PortfolioProject.dbo.[Nashville Housing]


UPDATE [Nashville Housing]
  Set SaleDate = CONVERT(Date, SaleDate)

  Alter Table [Nashville Housing]
  Add SaleDateConverted Date;

  UPDATE [Nashville Housing]
  Set SaleDateConverted = CONVERT(Date, SaleDate);


  -- Populate Property Adress

Select *
From PortfolioProject.dbo.[Nashville Housing]
-- Where PropertyAddress is Null
Order By ParcelID;

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.[Nashville Housing] a
Join PortfolioProject.dbo.[Nashville Housing] b
    on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null;


UPDATE a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.[Nashville Housing] a
Join PortfolioProject.dbo.[Nashville Housing] b
    on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	Where a.PropertyAddress is Null;


	-- Breaking out Address into individual Columns 

	Select PropertyAddress
From PortfolioProject.dbo.[Nashville Housing]
-- Where PropertyAddress is Null
--Order By ParcelID;

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,  CHARINDEX(',' , PropertyAddress)+1, LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.[Nashville Housing];

 
 Alter Table[PortfolioProject].[dbo].[Nashville Housing]
 Add PropertySplitAddress Nvarchar(255);

  UPDATE [PortfolioProject].[dbo].[Nashville Housing]
  Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress)-1);


  Alter Table [PortfolioProject].[dbo].[Nashville Housing]
  Add SaleSplitCity  Nvarchar(255);

  UPDATE [PortfolioProject].[dbo].[Nashville Housing]
  Set SaleSplitCity  = SUBSTRING(PropertyAddress,  CHARINDEX(',' , PropertyAddress)+1, LEN(PropertyAddress));


 -- SELECT * FROM fn_my_permissions(NULL, '[PortfolioProject]');

 Select *
 From [PortfolioProject].[dbo].[Nashville Housing]





 Select OwnerAddress
  From [PortfolioProject].[dbo].[Nashville Housing]

  Select 
  PARSENAME(REPLACE(OwnerAddress, ',','.'), 3),
  PARSENAME(REPLACE(OwnerAddress, ',','.'), 2),
  PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
  From [PortfolioProject].[dbo].[Nashville Housing];

  Alter Table[PortfolioProject].[dbo].[Nashville Housing]
 Add OwnerSplitAddress Nvarchar(255);

  UPDATE [PortfolioProject].[dbo].[Nashville Housing]
  Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)

Alter Table[PortfolioProject].[dbo].[Nashville Housing]
 Add OwnerSplitCity Nvarchar(255);

  UPDATE [PortfolioProject].[dbo].[Nashville Housing]
  Set OwnerSplitCity =  PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)


  Alter Table [PortfolioProject].[dbo].[Nashville Housing]
  Add OwnerSplitState  Nvarchar(255);

  UPDATE [PortfolioProject].[dbo].[Nashville Housing]
  Set OwnerSplitState  = PARSENAME(REPLACE(OwnerAddress, ',','.'), 1);



  Select *
 From [PortfolioProject].[dbo].[Nashville Housing];


 -- change Y and N into yes and no in SoldAsVacant field

 
  Select Distinct(SoldAsVacant)
 From [PortfolioProject].[dbo].[Nashville Housing]

 Select SoldAsVacant,
 Case When SoldAsVacant = 'Y' Then 'Yes'
      When SoldAsVacant = 'Y' Then 'No'
	  Else SoldAsVacant
	  End
 From [PortfolioProject].[dbo].[Nashville Housing]


 UPDATE [PortfolioProject].[dbo].[Nashville Housing]
 Set SoldAsVacant =  Case When SoldAsVacant = 'Y' Then 'Yes'
      When SoldAsVacant = 'Y' Then 'No'
	  Else SoldAsVacant
	  End


	  -- Removing Duplicates
	  With RownumCTE As(
	  Select *,
	  ROW_NUMBER() Over (
	  Partition By ParcelID,
	               PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
				   Order By
				      UniqueID
					   )row_num
From [PortfolioProject].[dbo].[Nashville Housing]
--Order BY ParcelID
)
Delete
From RownumCTE
Where row_num > 1
-- Order By PropertyAddress



 With RownumCTE As(
	  Select *,
	  ROW_NUMBER() Over (
	  Partition By ParcelID,
	               PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
				   Order By
				      UniqueID
					   )row_num
From [PortfolioProject].[dbo].[Nashville Housing]
--Order BY ParcelID
)
Select *
From RownumCTE
Where row_num > 1



--- Delete Unused Columns

Select *
From [PortfolioProject].[dbo].[Nashville Housing]

Alter Table [PortfolioProject].[dbo].[Nashville Housing]
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table [PortfolioProject].[dbo].[Nashville Housing]
Drop Column SaleDate;
