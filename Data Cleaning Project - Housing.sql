/*
Cleaning Data in SQL Queries
*/


Select *
From Housing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select saleDate, CONVERT(Date,SaleDate)
From Housing


Update Housing
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE Housing
Add SaleDateConverted Date;

Update Housing
SET SaleDateConverted = CONVERT(Date,SaleDate)


Select saleDateConverted, CONVERT(Date,SaleDate)
From Housing


--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From Housing
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From Housing a
JOIN Housing b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID  <> b.UniqueID 
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From Housing a
JOIN Housing b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID  <> b.UniqueID 
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

-- For PropertyAddress column

Select PropertyAddress
From Housing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTR(PropertyAddress, 1, POSITION(',' in PropertyAddress) -1 ) as Address
, SUBSTR(PropertyAddress, POSITION(',' in PropertyAddress) + 1 , LENGTH(PropertyAddress)) as City

From Housing


ALTER TABLE Housing
Add PropertySplitAddress Nvarchar(255);

Update Housing
SET PropertySplitAddress = SUBSTR(PropertyAddress, 1, POSITION(',' in PropertyAddress) -1 )


ALTER TABLE Housing
Add PropertySplitCity Nvarchar(255);

Update Housing
SET PropertySplitCity = SUBSTR(PropertyAddress, POSITION(',' in PropertyAddress) + 1 , LENGTH(PropertyAddress))





--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From Housing


Update Housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Housing
--order by ParcelID
)


Delete
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From Housing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From Housing


ALTER TABLE Housing
DROP COLUMN TaxDistrict, PropertyAddress, SaleDate




-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
