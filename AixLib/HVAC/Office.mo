within AixLib.HVAC;
package Office "Example application in an office building"
  extends Modelica.Icons.Package;
  package Room
    extends Modelica.Icons.Package;
  // use call to external cfd program to calulate air flow in a room

  model ExternalCInterfaceModelica_NoChange
      "Reads and writes Data from/to external C routine"
    ////////////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////
    public
    parameter Real Rate=20.0 "Sampling rate"
      annotation (Dialog(descriptionLabel=true, group="Connection"));
    parameter Integer LENGTH=1
        "Number of Variables to Send to External C Routine"                        annotation(Dialog(descriptionLabel=true,group="Connection"));
    parameter String Stringer= "Connected to External C Code!"
        "String to be sent to External C Code"
      annotation (Dialog(descriptionLabel=true, group="Connection"));
   parameter Modelica.SIunits.Time T_C=0.01
      annotation (Dialog(descriptionLabel=true, group="Relaxation"));

  parameter Real[ LENGTH] Initials "Initial values of output";

  Modelica.Blocks.Interfaces.RealInput[LENGTH] u annotation (Placement(
          transformation(extent={{-120,-20},{-80,20}}, rotation=0),
            iconTransformation(extent={{-120,20},{-80,-20}})));
   Modelica.Blocks.Interfaces.IntegerOutput Return
                                                  annotation (Placement(
          transformation(
          origin={0,-100},
          extent={{-20,-20},{20,20}},
          rotation=270)));

  Modelica.Blocks.Interfaces.RealOutput y    annotation (Placement(
          transformation(extent={{80,40},{120,80}},  rotation=0),
          iconTransformation(extent={{80,-80},{120,-40}})));
  Modelica.Blocks.Interfaces.RealOutput[LENGTH] yArray annotation (Placement(
          transformation(extent={{80,-80},{120,-40}},rotation=0),
          iconTransformation(extent={{80,40},{120,80}})));

    protected
   Boolean Trigger "Boolean Trigger acivating external function call";
   Real[LENGTH] PTYArray_raw
        "Real value array received by external function or program";
   Real PTY_raw "Real value received by external function or program";
    //////////////////////////////////////////////////////////

   Modelica.Blocks.Continuous.FirstOrder[LENGTH] PTYArray(each T=T_C,each  initType=
          Modelica.Blocks.Types.Init.InitialOutput,
      y_start=Initials)
      annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
   Modelica.Blocks.Continuous.FirstOrder PTY(each T=T_C,each  initType=Modelica.Blocks.Types.Init.InitialOutput,
      y_start=Initials[1])
      annotation (Placement(transformation(extent={{40,50},{60,70}})));

  initial algorithm

  // initializing the variables of external function or program
  (Return):=Functions.Starter(0.1,LENGTH,Stringer);

  algorithm
   when Trigger then
    // call of external function, writing the value u
    (Return):=Functions.Writer_NoChange(
                               u,LENGTH,Stringer);
    // call of external function, reading the array PTYArray_raw
     PTYArray_raw:=Functions.ReaderArray(u);

     // call of external function, reading the single value of PTY_raw
     PTY_raw:=Functions.Reader(1);

   end when;
    //////////////////////////////////////////////////////////
  equation
    Trigger = sample(0, Rate);

    // relaxation of output, preventing unnecessary function calls of internal time steps
    for i in 1:LENGTH loop
         PTYArray[i].u= PTYArray_raw[i];
    end for;

    PTY.u=PTY_raw;

    connect(PTYArray.y, yArray) annotation (Line(
        points={{61,-60},{100,-60}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(PTY.y, y) annotation (Line(
        points={{61,60},{100,60}},
        color={0,0,127},
        smooth=Smooth.None));
   annotation (                                Diagram(coordinateSystem(
              preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                       graphics),
                                                       Icon(coordinateSystem(
              preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                            graphics={Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,255},
              fillColor={175,175,175},
              fillPattern=FillPattern.Solid), Text(
              extent={{-74,66},{70,-74}},
              lineColor={0,0,0},
              fillColor={175,175,175},
              fillPattern=FillPattern.Solid,
              textString="C")}),
      conversion(noneFromVersion=""),
  Documentation(info="<html>
<h4><span style=\"color:#008000\">Overview</span></h4>
<p>Supplies access to external C functions. </p>
<h4><span style=\"color:#008000\">Level of Development</span></h4>
<p><img src=\"modelica://AixLib/Images/stars5.png\"/></p>
<h4><span style=\"color:#008000\">Concept</span></h4>
<p>Input: Arbitrary real array.</p>
<p>Output: Input value with no change according to sampling rate Rate</p>
<p>The output can be supplied individually (reader) or in a vector (readerArray). </p>
<p>reader(i) supplies value of array with index i</p>
<p>readerArray supplies the complete array</p>
<p>Corresponding code in ./Office/Code</p>
<h4><span style=\"color:#008000\">Known Limitations</span></h4>
<p>Interface requires a relaxation model to control the sampling rate.</p>
<h4><span style=\"color:#008000\">References</span></h4>
<h4><span style=\"color:#008000\">Example Results</span></h4>
<p><a href=\"AixLib.HVAC.Office.Examples.ExternalC\">AixLib.HVAC.Office.Examples.ExternalC</a></p>
</html>",
      revisions="<html>
<ul>
  <li><i>Feb 26, 2014&nbsp;</i> by Bjoern Flieger:<br/>Implemented</li>

</ul>
</html>"));
  end ExternalCInterfaceModelica_NoChange;

    package Functions
    extends Modelica.Icons.Package;
     function Starter
       input Real dou "Real value to be sent to external program";
       input Integer LENGTH "Integer value to be sent to external program";
       input String Stringer "String to be sent to external program";
       output Integer LengthOut
          "Integer value to be received from external program";
       external "C" LengthOut = starter(dou,LENGTH,Stringer);
       annotation (Include="#include <Header.h>",Library="ExternalC",
          Documentation(revisions="<html>
<ul>
  <li><i>Feb 26, 2014&nbsp;</i> by Bjoern Flieger:<br/>Implemented</li>

</ul>
</html>", info="<html>
<h4><span style=\"color:#008000\">Overview</span></h4>
<p>Function for sending and receivings a value.</p>
</html>"));
     end Starter;
      ////////////////////////////////////////////////////////////////////////////////
     function Writer_NoChange
       input Real[:] V "Real value to be sent to external program";
       input Integer LENGTH "Integer value to be sent to external program";
       input String Stringer "String to be sent to external program";
       output Integer Const
          "Integer value to be received from external program";
       external "C" Const = writerNoChange(V, LENGTH, Stringer);
       annotation (Include="#include <Header.h>",Library="ExternalC",
          Documentation(revisions="<html>
<ul>
  <li><i>Feb 26, 2014&nbsp;</i> by Bjoern Flieger:<br/>Implemented</li>

</ul>
</html>", info="<html>
<h4><span style=\"color:#008000\">Overview</span></h4>
<p>Function for wirting a value.</p>
</html>"));
     end Writer_NoChange;

      ////////////////////////////////////////////////////////////////////////////////

     function Reader
       input Integer index "Integer value to be sent to external program";
       output Real W "Real value to be received from external program";
       external "C" W = reader(index);
       annotation (Include="#include <Header.h>",Library="ExternalC",
          Documentation(revisions="<html>
<ul>
  <li><i>Feb 26, 2014&nbsp;</i> by Bjoern Flieger:<br/>Implemented</li>

</ul>
</html>", info="<html>
<h4><span style=\"color:#008000\">Overview</span></h4>
<p>Function for reading a value.</p>
</html>"));
     end Reader;
      ////////////////////////////////////////////////////////////////////////////////
      function ReaderArray
        input Real H[:] "Integer array to be sent to external program";
        output Real HBack[ size(H,1)]
          "Real array to be received from external program";
        external "C" readerArray(H,HBack,size(H,1));
        annotation (Include="#include <Header.h>",Library="ExternalC",
          Documentation(revisions="<html>
<ul>
  <li><i>Feb 26, 2014&nbsp;</i> by Bjoern Flieger:<br/>Implemented</li>

</ul>
</html>", info="<html>
<h4><span style=\"color:#008000\">Overview</span></h4>
<p>Function for reading an array.</p>
</html>"));
      end ReaderArray;

    end Functions;

  end Room;

  package Examples
    extends Modelica.Icons.ExamplesPackage;

    model ExternalC
      extends Modelica.Icons.Example;

    parameter Real Rate=1;

      Room.ExternalCInterfaceModelica_NoChange   externalC(
        Stringer="Hello External C, I am Modelica",
        Rate=Rate,
        LENGTH=3,
        Initials={0,1,-2})
        annotation (Placement(transformation(extent={{0,-20},{40,20}})));
      Modelica.Blocks.Sources.Sine sine(amplitude=3, freqHz=0.01)
        annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
      Modelica.Blocks.Sources.Clock clock
        annotation (Placement(transformation(extent={{20,60},{40,80}})));
      Modelica.Blocks.Sources.Ramp ramp(
        height=4,
        duration=30,
        startTime=40,
        offset=1)
        annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
      Modelica.Blocks.Sources.Step step(
        height=2,
        startTime=50,
        offset=-2)
        annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
    equation

      connect(sine.y, externalC.u[1]) annotation (Line(
          points={{-59,40},{-30,40},{-30,2.66667},{0,2.66667}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(ramp.y, externalC.u[2])  annotation (Line(
          points={{-59,0},{-30.5,0},{-30.5,-2.22045e-016},{0,-2.22045e-016}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(step.y, externalC.u[3])   annotation (Line(
          points={{-59,-40},{-30,-40},{-30,-2},{0,-2},{0,-2.66667}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (
        Diagram(coordinateSystem(extent={{-120,-100},{100,100}},
              preserveAspectRatio=false), graphics={
                                       Text(
              extent={{-38,-36},{76,-66}},
              lineColor={0,0,255},
              textString="Send 3 different signals to external function/program"), Text(
              extent={{-120,-68},{100,-108}},
              lineColor={0,0,255},
              textString="Header.h and ExternalC.lib from library directory Office\\Libs\\ 
must be present in the current working directory!
Alternatively the PATH and INCLUDE variables can be adjusted according to the specified location.
")}),   Icon(coordinateSystem(extent={{-120,-100},{100,100}})),
        experiment(
          StopTime=100,
          Interval=0.1,
          __Dymola_Algorithm="Lsodar"),
        __Dymola_experimentSetupOutput(events=false),
        Documentation(revisions="<html>
<p>24.01.14, Bjoern Flieger</p>
<p><ul>
<li>Implemented full example</li>
</ul></p>
<p>23.01.14, Bjoern Flieger</p>
<p><ul>
<li>Implemented first draft</li>
</ul></p>
</html>", info="<html>
<h4><span style=\"color:#008000\">Overview</span></h4>
<p>This example illustrates the usage of external C functions.</p>
</html>"));
    end ExternalC;

  end Examples;
end Office;
