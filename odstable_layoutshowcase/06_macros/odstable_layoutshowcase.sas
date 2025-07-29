/*** HELP START ***//*

Macro   : odstable_layoutshowcase
 Purpose   : Showcase of PROC ODSTABLE layout patterns with RTF output generator
             - Generates multi-patterned tables with custom headers/footers
             - Demonstrates cell merging, grouping, pagination, and style templates
             - Designed for instructional, reference, and reusable reporting workflows

 Author    : Yutaka Morioka

 Usage     : 
   %odstable_layoutshowcase(outpath=..., sampleno=1~4);

 Outputs   : 
   - RTF file(s) with pre-defined table layout samples
   - Corresponding template and macro code as .txt for inspection

Useage Exampke
%odstable_layoutshowcase(sampleno=1);
%odstable_layoutshowcase(sampleno=2);
%odstable_layoutshowcase(sampleno=3);
%odstable_layoutshowcase(sampleno=4);
%odstable_layoutshowcase(sampleno=1, outpath =output directory path);



# Key Features of Sample 1
  Multiple Variables in a Single Cell:
  When multiple variables are output into the same cell, they are enclosed in parentheses to visually group them together.
  Line Breaks in Header Labels:
  Line breaks within header text can be defined using a custom delimiter specified by the split= option (e.g., #), allowing for clean vertical formatting.
  Hierarchical Header Structure:
  Header levels are built by stacking multiple define header statements, where each level is defined by its corresponding start= and end= variable range. This approach enables clear and layered multi-row headers.

# Key Features of Sample 3
  Conditional Styling with cellstyle:
  Borders can be applied conditionally using syntax like
  cellstyle condition as data{borderbottomwidth=1}, enabling precise control over table appearance based on data values.
  Page Breaks via PRETEXT:
  You can insert page breaks programmatically using PRETEXT="(*ESC*)R'\pagebb'", which outputs an RTF escape sequence before the target cell.
  Targeting Specific Rows or Columns:
  The example also demonstrates the use of _row_ and _col_ in condition expressions, showing how to selectively apply styles to specific rows or columns in the table layout.

# Key Features of Sample 4
 Composite Layout within a Single Report:
 By specifying startpage=no in the ODS RTF statement, multiple tables can be rendered within a single RTF page flow, enabling composite layouts in one report.

Footnote Area Adjustment Using a Gap Column:
The example demonstrates how to define a gap column to reserve space for footnotes in the second table.
This ensures consistent layout and prevents footnotes from overlapping with table content

 License   : MIT-style (Free to use and modify with attribution)

 Remarks   :
   This package is part of the "odstable_layoutshowcase" project, designed as a 
   reference implementation and educational tool for RTF table layout construction.
   Intended for use in clinical trial reporting, programming education, and template 
   standardization efforts.

*//*** HELP END ***/

%macro odstable_layoutshowcase(outpath=,sampleno=1);

%let workpath = %sysfunc(pathname(WORK));
%if %length(&outpath) = 0 %then %do;
  %let outpath=&workpath;
%end;
data dummy;
length out1-out10 $200.;
array ar out1-out10;
do i = 1 to 7;
do over ar;
 ar=repeat(char("ABCDEFGHIJKLMNOPQRSTUVWXYZ",_i_),3);
end;
if i in (1,3,5) then line =1;
if i in (2,4) then line =2;
if i in (3,5) then break ="Y";
output;
call missing(of break line);
end;
drop i;
run;

%macro style;
ods path (prepend) work.rtfstyle(update);
    proc template;
    define style work.sample_style;
    parent=styles.rtf;
    style systemtitle/
      fontfamily = "Times New Roman"
      font_size  = 9pt
      font_weight= medium
      font_style = roman
      foreground = black
      background = white
      ;
    style systemfooter/
      font_face = "Times New Roman"
      font_size = 9pt
      font_weight = medium
      font_style = roman
      foreground = black
      background = white
      ;
    style header/
      font_face = "Times New Roman"
      font_size = 9pt
      font_weight = medium
      font_style = roman
      foreground = black
      background = white
      ;
    style footer/
      font_face = "Times New Roman"
      font_size = 9pt
      font_weight = medium
      font_style = roman
      foreground = black
      background = white
      ;
    style data/
      font_face = "Times New Roman"
      font_size = 9pt
      font_weight = medium
      font_style = roman
      foreground = black
      background = white
      ;
    style table/
      foreground = black
      background = white
      cellspacing = 1
      cellpadding = 1
      frame = hsides
      rules = groups
      just  = left
      borderwidth = 0.5pt
      bordercolor = black
      borderstyle = solid
      ;
    style body/
      foreground = black
      background = white
      topmargin = 1.0in
      bottommargin = 1.0in
      leftmargin  = 1.0in
      rightmargin = 1.0in
      ;
    replace Output from Container/
      borderwidth = 1
      cellspacing = 1
      cellpadding = 1
      frame = hsides
      rules = groups
     ;
    end;
  run;
%mend style;


filename style "&outpath./template_style.txt";
filename temp temp;
proc stream outfile=temp ;
begin
%style;
;;;;
run;

data _null;
length line newline $32767.;
    infile temp lrecl=32767 TRUNCOVER;
    input line $32767.;
    newline=tranwrd(line,"    ",'0D0A'x);
    file style;
    put newline;
run;
filename temp clear;



    %macro sample1;
    options nocenter nodate nonumber orientation=landscape;
    ods rtf file = "&outpath\sample_1_Listing_1.rtf" style=work.sample_style ;
    title1 "Sample 1--Listing 1" ;
    title2 "Proc ODSTABLE";
    proc odstable data= dummy;
     column out1 - out6 (out7-out8) out9 out10;
    /*Header*/
    define header header1; start=out1; end=out1; vjust=top; split="#"; just=left;text "AAAA";end;
     define header header2; start=out2; end=out2; vjust=top; split="#"; just=left;text "BBBB#(bbbb)";end;
     define header header3; start=out3; end=out3; vjust=top; split="#"; just=left;text "CCCC";end;
     define header header4; start=out4; end=out4; vjust=top; split="#"; just=left;text "DDDD"; end;
     define header header5; start=out5; end=out5; vjust=top; split="#"; just=left;text "EEEE#(eeee)"; end;
     define header header6; start=out6; end=out6; vjust=top; split="#"; just=left;text "FFFF"; end;
     define header header7; start=out7; end=out7; vjust=top; split="#"; just=left;text "GGGG /#HHHH"; end;
     define header header9_10; start=out9; end=out10; vjust=top; split="#"; just=center;style={borderbottomstyle=solid borderbottomwidth=1};text "IIIIJJJJ"; end;
     define header header9; start=out9; end=out9; vjust=top; split="#"; just=center;text "IIII"; end;
     define header header10; start=out10; end=out10; vjust=top; split="#"; just=center;text "JJJJ"; end;
    /*Column*/
    define out1; print_headers=off; just=left; style={cellwidth=120}; end;
     define out2; print_headers=off; just=left; style={cellwidth=120}; end;
     define out3; print_headers=off; just=left; style={cellwidth=120}; end;
     define out4; print_headers=off; just=left; style={cellwidth=120}; end;
     define out5; print_headers=off; just=left; style={cellwidth=120}; end;
     define out6; print_headers=off; just=left; style={cellwidth=120}; end;
     define out7; print_headers=off; just=left; style={cellwidth=120}; end;
     define out9; print_headers=off; just=center; style={cellwidth=120}; end;
     define out10; print_headers=off; just=center; style={cellwidth=120}; end;
    /* Footer*/
    define footer MYFOOT1; just=left; style={borderbottomstyle=hidden}; text "Footer1 xxxxxxx"; end;
     define footer MYFOOT2; just=left; style={borderbottomstyle=hidden}; text "Footer2 xxxxxxx"; end;

    run;
    ods rtf close;
    %mend;

    %macro sample2;
    options nocenter nodate nonumber orientation=landscape;
    ods rtf file = "&outpath\sample_2_Table_1.rtf" style=work.sample_style ;
    title1 "Sample 2--Table 1" ;
    title2 "Proc ODSTABLE";
    proc odstable data= dummy;
     column out1 - out5;
    /*Header*/
    define header header1; start=out1; end=out1; vjust=top; split="#"; just=center;text "";end;
     define header header2; start=out2; end=out2; vjust=top; split="#"; just=center;text "";end;
     define header header3_4; start=out3; end=out4; vjust=top; split="#"; just=center;style={borderbottomstyle=solid borderbottomwidth=1};text "Treatment";end;
     define header header3; start=out3; end=out3; vjust=top; split="#"; just=center;text "Group 1# N = xx#n (%)";end;
     define header header4; start=out4; end=out4; vjust=top; split="#"; just=center;text "Group 2# N = xx#n (%)"; end;
     define header header5; start=out5; end=out5; vjust=top; split="#"; just=center;text "Placebo# #N = xx#n (%)"; end;
    /*Column*/
    define out1; print_headers=off; just=center; style={cellwidth=220}; end;
     define out2; print_headers=off; just=center; style={cellwidth=200}; end;
     define out3; print_headers=off; just=center; style={cellwidth=150}; end;
     define out4; print_headers=off; just=center; style={cellwidth=150}; end;
     define out5; print_headers=off; just=center; style={cellwidth=150}; end;
    /* Footer*/
    define footer MYFOOT1; just=left; style={borderbottomstyle=hidden}; text "Footer1 xxxxxxx"; end;
     define footer MYFOOT2; just=left; style={borderbottomstyle=hidden}; text "Footer2 xxxxxxx"; end;

    run;
    ods rtf close;
    %mend;


    %macro sample3;
    options nocenter nodate nonumber orientation=landscape;
    ods rtf file = "&outpath\sample_3_Table_2.rtf" style=work.sample_style ;
    title1 "Sample 3--Table 2" ;
    title2 "Proc ODSTABLE";
    proc odstable data= dummy;
     cellstyle break="Y" as data{PRETEXT="(*ESC*)R'\pagebb' " }
     ,line=1 and 2<=_col_ as data{borderbottomwidth=1}
     ,line=2 as data{borderbottomwidth=1};

     column out1 - out6 break line;
    /*Header*/
    define header header1; start=out1; end=out1; vjust=top; split="#"; just=center;text "";end;
     define header header2; start=out2; end=out2; vjust=top; split="#"; just=center;text "";end;
     define header header3_6; start=out3; end=out6; vjust=top; split="#"; just=center;style={borderbottomstyle=solid borderbottomwidth=1};text "Toplevel";end;
     define header header3_4; start=out3; end=out4; vjust=top; split="#"; just=center;style={borderbottomstyle=solid borderbottomwidth=1};text "2nd";end;
     define header header3; start=out3; end=out3; vjust=top; split="#"; just=center;text "3rd# N = xx#n (%)";end;
     define header header4; start=out4; end=out4; vjust=top; split="#"; just=center;text "3rd# N = xx#n (%)"; end;
     define header header5_6; start=out5; end=out6; vjust=top; split="#"; just=center;style={borderbottomstyle=solid borderbottomwidth=1};text "2nd";end;
     define header header5; start=out5; end=out5; vjust=top; split="#"; just=center;text "3rd# N = xx#n (%)";end;
     define header header6; start=out6; end=out6; vjust=top; split="#"; just=center;text "3rd# N = xx#n (%)"; end;
    /*Column*/
    define out1; print_headers=off; just=center; style={cellwidth=220}; end;
     define out2; print_headers=off; just=center; style={cellwidth=200}; end;
     define out3; print_headers=off; just=center; style={cellwidth=150}; end;
     define out4; print_headers=off; just=center; style={cellwidth=150}; end;
     define out5; print_headers=off; just=center; style={cellwidth=150}; end;
     define out6; print_headers=off; just=center; style={cellwidth=150}; end;
     define break; print=no; end;
     define line; print=no; end;

    /* Footer*/
    define footer MYFOOT1; just=left; style={borderbottomstyle=hidden}; text "Footer1 xxxxxxx"; end;
     define footer MYFOOT2; just=left; style={borderbottomstyle=hidden}; text "Footer2 xxxxxxx"; end;

    run;
    ods rtf close;
    %mend;

    %macro sample4;
    options nocenter nodate nonumber orientation=landscape;
    ods rtf file = "&outpath\sample_4_Table_3.rtf" style=work.sample_style startpage=no;
    title1 "Sample 4--Table 3" ;
    title2 "Proc ODSTABLE";
    proc odstable data= dummy(where=(^missing(line)));
     column out1 - out5;
    /*Header*/
    define header header1; start=out1; end=out1; vjust=top; split="#"; just=center;text "";end;
     define header header2; start=out2; end=out2; vjust=top; split="#"; just=center;text "";end;
     define header header3_4; start=out3; end=out4; vjust=top; split="#"; just=center;style={borderbottomstyle=solid borderbottomwidth=1};text "Treatment";end;
     define header header3; start=out3; end=out3; vjust=top; split="#"; just=center;text "Group 1# N = xx#n (%)";end;
     define header header4; start=out4; end=out4; vjust=top; split="#"; just=center;text "Group 2# N = xx#n (%)"; end;
     define header header5; start=out5; end=out5; vjust=top; split="#"; just=center;text "Placebo# #N = xx#n (%)"; end;

	 /*Column*/
    define out1; print_headers=off; just=center; style={cellwidth=220}; end;
     define out2; print_headers=off; just=center; style={cellwidth=200}; end;
     define out3; print_headers=off; just=center; style={cellwidth=150}; end;
     define out4; print_headers=off; just=center; style={cellwidth=150}; end;
     define out5; print_headers=off; just=center; style={cellwidth=150}; end;
    /* Footer*/
    define footer MYFOOT1; just=left; style={borderbottomstyle=hidden}; text "Footer1 xxxxxxx"; end;
     define footer MYFOOT2; just=left; style={borderbottomstyle=hidden}; text "Footer2 xxxxxxx"; end;

    run;

    proc odstable data= dummy(where=(missing(line)));
     column out1 - out2 gap;
    /*Header*/
    define header header1; start=out1; end=out1; vjust=top; split="#"; just=center;text "XXXX";end;
     define header header2; start=out2; end=out2; vjust=top; split="#"; just=center;text "YYYY";end;
	   define header gap_header; start=gap; end=gap;text " (*ESC*)S={borderbottomstyle=hidden bordertopstyle=hidden} "; end;
    /* Footer*/
    define footer MYFOOT1; just=left; style={borderbottomstyle=hidden}; text "Footer1 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"; end;
    define footer MYFOOT2; just=left; style={borderbottomstyle=hidden}; text "Footer2 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"; end;
    /*Column*/
    define out1; print_headers=off; just=center; style={cellwidth=220}; end;
     define out2; print_headers=off; just=center; style={cellwidth=200}; end;
	 define gap;     compute as (""); style={borderbottomstyle=hidden bordertopstyle=hidden cellwidth=650};                      

    run;

    ods rtf close;
    %mend;


    data _null_;
      rc=filename("dum","&outpath./sample&sampleno..txt");
      rc=fdelete("dum");
    run;

filename sample "&outpath./sample&sampleno..txt";
filename temp temp;
proc stream outfile=temp ;
begin
%sample&sampleno.
;;;;
run;

data _null;
length line newline $32767.;
    infile temp lrecl=32767 TRUNCOVER;
    input line $32767.;
    newline=tranwrd(line,"    ",'0D0A'x);
    file sample;
    put newline;
run;
filename temp clear;

  options noxwait noxsync;
  data _null_;
      call sleep(1,1);
  run;
  %sysexec "&outpath./sample&sampleno..txt";

  data _null_;
      call sleep(1,1);
  run;
  %sysexec "&outpath./template_style.txt";

%sample&sampleno.


%mend;
