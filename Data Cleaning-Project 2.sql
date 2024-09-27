select*
From [Nashville Housing Data for Data Cleaning];

-- Stanardize Date Format

Select SaleDate, CONVERT (Date,SaleDate)
From [Nashville Housing Data for Data Cleaning];

Update [Nashville Housing Data for Data Cleaning]
SET SaleDate = CONVERT(Date, SaleDate);

Alter Table [Nashville Housing Data for Data Cleaning]
ADD SaleDateConverted Date;

Update [Nashville Housing Data for Data Cleaning]
SET SaleDateConverted = CONVERT (Date, SaleDate)

Select SaleDateConverted, CONVERT (Date,SaleDate)
From [Nashville Housing Data for Data Cleaning];


-- Popular Property Address Data

Select *
From [Nashville Housing Data for Data Cleaning]
Where PropertyAddress is Null;

Select *
From [Nashville Housing Data for Data Cleaning]
ORDER by ParcelID

Select A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
From [Nashville Housing Data for Data Cleaning] A
JOIN [Nashville Housing Data for Data Cleaning] B
	On A.ParcelID = B.ParcelID
	AND A. [UniqueID]<> B.[UniqueID]
Where A.PropertyAddress is NULL

Update A
Set PropertyAddress = ISNULL (A.PropertyAddress, B.PropertyAddress)
From [Nashville Housing Data for Data Cleaning] A
JOIN [Nashville Housing Data for Data Cleaning] B
	On A.ParcelID = B.ParcelID
	AND A. [UniqueID]<> B.[UniqueID]
Where A.PropertyAddress is NULL


-- Breaking out Address into Individual Columns (Address, City, State) 
Select PropertyAddress
From [Nashville Housing Data for Data Cleaning]

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
	SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, Len(PropertyAddress))  as Address
From [Nashville Housing Data for Data Cleaning]


Alter Table [Nashville Housing Data for Data Cleaning]
ADD PropertySplitAddress Nvarchar(225);

Update [Nashville Housing Data for Data Cleaning]
Set PropertySplitAddress = 	SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1)


Alter Table [Nashville Housing Data for Data Cleaning]
Add PropertySpiltCity Nvarchar(225); 

Update [Nashville Housing Data for Data Cleaning]
Set PropertySpiltCity =SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, Len(PropertyAddress)) 

--Select*
--From [Nashville Housing Data for Data Cleaning]


Select OwnerAddress
From [Nashville Housing Data for Data Cleaning]

Select 
PARSENAME(Replace(OwnerAddress, ',', '.') ,3),
PARSENAME(Replace(OwnerAddress, ',', '.') ,2),
PARSENAME(Replace(OwnerAddress, ',', '.') ,1)
From [Nashville Housing Data for Data Cleaning]

Alter Table [Nashville Housing Data for Data Cleaning]
ADD OwnerSplitAddress Nvarchar(225);

Update [Nashville Housing Data for Data Cleaning]
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.') ,3)


Alter Table [Nashville Housing Data for Data Cleaning]
Add OwnerSplitCity Nvarchar(225); 

Update [Nashville Housing Data for Data Cleaning]
Set OwnerSplitCity =PARSENAME(Replace(OwnerAddress, ',', '.') ,2)

Alter Table [Nashville Housing Data for Data Cleaning]
Add OwnerSplitState Nvarchar(225); 

Update [Nashville Housing Data for Data Cleaning]
Set OwnerSplitState =PARSENAME(Replace(OwnerAddress, ',', '.') ,1) 

--Select *
--From [Nashville Housing Data for Data Cleaning]

-- Change Y and N to Yes and No in "Sold as Vacant" Field

Select Distinct (SoldAsVacant), Count (SoldAsVacant)
From [Nashville Housing Data for Data Cleaning]
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
	Case When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	END
From [Nashville Housing Data for Data Cleaning]

Update [Nashville Housing Data for Data Cleaning]
SET SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	END

Select Distinct (SoldAsVacant), Count (SoldAsVacant)
From [Nashville Housing Data for Data Cleaning]
Group by SoldAsVacant
Order by 2


-- Remove Duplicates

With RowNumCTE as (
Select *,
	ROW_NUMBER() Over(
	PARTITION By ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order by 
					UniqueID
					) row_num
From [Nashville Housing Data for Data Cleaning]
)
Delete
From RowNumCTE
where row_num > 1

-- Delete Unused Columns

Select *
From [Nashville Housing Data for Data Cleaning]

Alter Table [Nashville Housing Data for Data Cleaning]
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table [Nashville Housing Data for Data Cleaning]
Drop Column SaleDate


