# odstable_layoutshowcase
A SAS macro toolkit to showcase layout patterns using PROC ODSTABLE. Provides reusable examples of table design with multi-level headers, conditional formatting, composite layouts, and auto-generated RTF output. Ideal for clinical reporting, style template development, and training use.

<img width="250" height="250" alt="Image" src="https://github.com/user-attachments/assets/d3d90344-f5d9-4e25-b1d5-999e7027abec" />

# %odstable_layoutshowcase()
 Purpose   : Showcase of PROC ODSTABLE layout patterns with RTF output generator  
             - Generates multi-patterned tables with custom headers/footers  
             - Demonstrates cell merging, grouping, pagination, and style templates  
             - Designed for instructional, reference, and reusable reporting workflows  
 Usage     :  
~~~text
   %odstable_layoutshowcase(outpath=..., sampleno=1~4);
~~~
 Outputs   : 
 ~~~text
   - RTF file(s) with pre-defined table layout samples
   - Corresponding template and macro code as .txt for inspection
~~~
## Useage Example
 ~~~sas
%odstable_layoutshowcase(sampleno=1);
~~~
![odstable_layoutshowcase](./picture/1-3.png)  
![odstable_layoutshowcase](./picture/1-1.png)  
![odstable_layoutshowcase](./picture/1-2.png) 

### Key Features of Sample 1
  Multiple Variables in a Single Cell:  
  When multiple variables are output into the same cell, they are enclosed in parentheses to visually group them together.  
  Line Breaks in Header Labels:  
  Line breaks within header text can be defined using a custom delimiter specified by the split= option (e.g., #), allowing for clean vertical formatting.  
  Hierarchical Header Structure:  
  Header levels are built by stacking multiple define header statements, where each level is defined by its corresponding start= and end= variable range. This approach enables clear and layered multi-row headers.  

    
 ~~~sas
%odstable_layoutshowcase(sampleno=2);
~~~
![odstable_layoutshowcase](./picture/2-2.png)  
![odstable_layoutshowcase](./picture/2-1.png)
 ~~~sas
%odstable_layoutshowcase(sampleno=3);
~~~
![odstable_layoutshowcase](./picture/3-2.png)  
![odstable_layoutshowcase](./picture/3-1.png)

### Key Features of Sample 3
  Conditional Styling with cellstyle:  
  Borders can be applied conditionally using syntax like  
  cellstyle condition as data{borderbottomwidth=1}, enabling precise control over table appearance based on data values.  
  Page Breaks via PRETEXT:   
  You can insert page breaks programmatically using PRETEXT="(*ESC*)R'\pagebb'", which outputs an RTF escape sequence before the target cell.  
  Targeting Specific Rows or Columns:  
  The example also demonstrates the use of _row_ and _col_ in condition expressions, showing how to selectively apply styles to specific rows or columns in the table layout.   


 ~~~sas
%odstable_layoutshowcase(sampleno=4);
~~~
![odstable_layoutshowcase](./picture/4-2.png)  
![odstable_layoutshowcase](./picture/4-1.png)


### Key Features of Sample 4
 Composite Layout within a Single Report:  
 By specifying startpage=no in the ODS RTF statement, multiple tables can be rendered within a single RTF page flow, enabling composite layouts in one report.  
 Footnote Area Adjustment Using a Gap Column:  
 The example demonstrates how to define a gap column to reserve space for footnotes in the second table.  
 This ensures consistent layout and prevents footnotes from overlapping with table content  

 # version history
0.1.0(30July2025): Initial version

## What is SAS Packages?  
The package is built on top of **SAS Packages framework(SPF)** developed by Bartosz Jablonski.
For more information about SAS Packages framework, see [SAS_PACKAGES](https://github.com/yabwon/SAS_PACKAGES).  
You can also find more SAS Packages(SASPACs) in [SASPAC](https://github.com/SASPAC).

## How to use SAS Packages? (quick start)
### 1. Set-up SPF(SAS Packages Framework)
Firstly, create directory for your packages and assign a fileref to it.
~~~sas      
filename packages "\path\to\your\packages";
~~~
Secondly, enable the SAS Packages Framework.  
(If you don't have SAS Packages Framework installed, follow the instruction in [SPF documentation](https://github.com/yabwon/SAS_PACKAGES/tree/main/SPF/Documentation) to install SAS Packages Framework.)  
~~~sas      
%include packages(SPFinit.sas)
~~~  
### 2. Install SAS package  
Install SAS package you want to use using %installPackage() in SPFinit.sas.
~~~sas      
%installPackage(packagename, sourcePath=\github\path\for\packagename)
~~~
(e.g. %installPackage(ABC, sourcePath=https://github.com/XXXXX/ABC/raw/main/))  
### 3. Load SAS package  
Load SAS package you want to use using %loadPackage() in SPFinit.sas.
~~~sas      
%loadPackage(packagename)
~~~
### Enjoy😁
