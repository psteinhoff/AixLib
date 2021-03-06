within AixLib.Utilities;
package Examples "Examples for BaseLib Components"
  extends Modelica.Icons.ExamplesPackage;

model HeatConv_outside
extends Modelica.Icons.Example;

    HeatTransfer.HeatConv_outside heatTransfer_Outside(Model=3,
      A=16,
      alpha_custom=25)
      annotation (Placement(transformation(extent={{-24,-2},{2,24}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature Tinside
      annotation (Placement(transformation(extent={{40,20},{20,40}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature Toutside
      annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-50,30})));
    Modelica.Blocks.Sources.RealExpression Windspeed(y=4)
      annotation (Placement(transformation(extent={{-60,-26},{-40,-6}})));
    Modelica.Blocks.Sources.Constant const(k=10 + 273.15)
      annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
    Modelica.Blocks.Sources.Constant const1(k=20 + 273.15)
      annotation (Placement(transformation(extent={{80,20},{60,40}})));
    Modelica.Blocks.Sources.RealExpression HeatFlow(y=heatTransfer_Outside.port_b.Q_flow)
      annotation (Placement(transformation(extent={{20,-44},{40,-24}})));
equation
    connect(const.y, Toutside.T) annotation (Line(
        points={{-79,30},{-70,30},{-70,30},{-62,30},{-62,30},{-62,30}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(const1.y, Tinside.T) annotation (Line(
        points={{59,30},{42,30}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(heatTransfer_Outside.port_a, Toutside.port) annotation (Line(
        points={{-24,11},{-34,11},{-34,30},{-40,30}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(heatTransfer_Outside.port_b, Tinside.port) annotation (Line(
        points={{2,11},{10,11},{10,30},{20,30}},
        color={191,0,0},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{
              -100,-100},{100,100}}),
                        graphics),
                         Documentation(revisions="<html>
<ul>
  <li><i>April 11, 2013&nbsp;</i> by Ole Odendahl:<br/>Formatted documentation appropriately</li>
  <li><i>October 14, 2012&nbsp;</i>
         by Ana Constantin:<br>
         Implemented.</li>
</ul>
</html>",
        info="<html>
<p><h4><font color=\"#008000\">Overview</font></h4></p>
<p>Plot HeatFlow for the different ways of calcutating the heat transfer to see the difference. </p>
</html>"),
      experiment(
        StopTime=3600,
        Interval=60,
        Algorithm="Lsodar"),
      experimentSetupOutput);
end HeatConv_outside;

  model HeatTransfer_test "Test routine for heat transfer models"
  extends Modelica.Icons.Example;

    HeatTransfer.HeatConv heatConv(alpha=2, A=16)
      annotation (Placement(transformation(extent={{-10,38},{10,58}})));
    Modelica.Thermal.HeatTransfer.Components.HeatCapacitor load(C=(1000)*(1600)
          *(16)*(0.2))
      annotation (Placement(transformation(extent={{-10,20},{10,40}})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor heatCond(G=(16)*(
          2.4)/(0.1))
      annotation (Placement(transformation(extent={{-10,2},{10,22}})));
    HeatTransfer.HeatConv_inside heatConv_universal(A=16, alpha_custom=2,
      surfaceOrientation=2)
      annotation (Placement(transformation(extent={{-10,-18},{10,2}})));
    HeatTransfer.HeatConv_outside heatTransfer_Outside(
      Model=1,
      A=16,
      alpha_custom=25,
      surfaceType=DataBase.Surfaces.RoughnessForHT.Brick_RoughPlaster())
      annotation (Placement(transformation(extent={{-10,-38},{10,-18}})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor heatTrans(G=(16)*
          (1.5))
      annotation (Placement(transformation(extent={{-10,-56},{10,-36}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TempOutside
      annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TempInside
      annotation (Placement(transformation(extent={{80,0},{60,20}})));
    Modelica.Blocks.Sources.Sine sineWindSpeed(amplitude=10, freqHz=0.5)
      annotation (Placement(transformation(extent={{-34,-24},{-24,-14}})));
    Modelica.Blocks.Interfaces.RealOutput Q_flow[6]
      annotation (Placement(transformation(extent={{76,50},{94,68}})));
    Modelica.Blocks.Sources.Constant constTempOutside(k=283)
      annotation (Placement(transformation(extent={{-100,-20},{-86,-6}})));
    Modelica.Blocks.Sources.Constant constTempInside(k=298) annotation (
        Placement(transformation(
          extent={{7,-7},{-7,7}},
          rotation=0,
          origin={93,-15})));
  equation
  //Connecting the Heat Flow Output, models as stated below in source code
  Q_flow[1] =heatConv.port_b.Q_flow;
  Q_flow[2] =load.port.Q_flow;
  Q_flow[3] =heatCond.port_b.Q_flow;
  Q_flow[4] =heatConv_universal.port_b.Q_flow;
  Q_flow[5] =heatTransfer_Outside.port_b.Q_flow;
  Q_flow[6] =heatTrans.port_b.Q_flow;

    connect(TempOutside.port, load.port) annotation (Line(
        points={{-60,10},{-40,10},{-40,20},{0,20}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(TempOutside.port, heatCond.port_a) annotation (Line(
        points={{-60,10},{-40,10},{-40,12},{-10,12}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(TempOutside.port, heatConv_universal.port_a) annotation (Line(
        points={{-60,10},{-40,10},{-40,-8},{-10,-8}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(heatConv.port_b, TempInside.port) annotation (Line(
        points={{10,48},{46,48},{46,10},{60,10}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(heatCond.port_b, TempInside.port) annotation (Line(
        points={{10,12},{46,12},{46,10},{60,10}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(heatConv_universal.port_b, TempInside.port) annotation (Line(
        points={{10,-8},{46,-8},{46,10},{60,10}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(sineWindSpeed.y, heatTransfer_Outside.WindSpeedPort) annotation (Line(
        points={{-23.5,-19},{-18,-19},{-18,-35.2},{-9.2,-35.2}},
        color={0,0,127},
        smooth=Smooth.None));

    connect(TempOutside.port, heatConv.port_a) annotation (Line(
        points={{-60,10},{-40,10},{-40,48},{-10,48}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(constTempOutside.y, TempOutside.T) annotation (Line(
        points={{-85.3,-13},{-82,-13},{-82,10}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(constTempInside.y, TempInside.T) annotation (Line(
        points={{85.3,-15},{84,-15},{84,-16},{84,-16},{84,10},{82,10}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(TempOutside.port, heatTrans.port_a) annotation (Line(
        points={{-60,10},{-40,10},{-40,-46},{-10,-46}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(heatTrans.port_b, TempInside.port) annotation (Line(
        points={{10,-46},{46,-46},{46,10},{60,10}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(heatTransfer_Outside.port_a, TempOutside.port) annotation (Line(
        points={{-10,-28},{-40,-28},{-40,10},{-60,10}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(heatTransfer_Outside.port_b, TempInside.port) annotation (Line(
        points={{10,-28},{46,-28},{46,10},{60,10}},
        color={191,0,0},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={
          Text(
            extent={{14,46},{26,36}},
            lineColor={0,0,255},
            textString="1"),
          Text(
            extent={{14,30},{26,20}},
            lineColor={0,0,255},
            textString="2"),
          Text(
            extent={{14,10},{26,0}},
            lineColor={0,0,255},
            textString="3"),
          Text(
            extent={{14,-10},{26,-20}},
            lineColor={0,0,255},
            textString="4"),
          Text(
            extent={{14,-30},{26,-40}},
            lineColor={0,0,255},
            textString="5"),
          Text(
            extent={{14,-48},{26,-58}},
            lineColor={0,0,255},
            textString="6")}),              Documentation(info="<html>
<h4><span style=\"color:#008000\">Overview</span></h4>
<p>Test routine to check simple heat transfer models with a maximum of 2 temperature connectors.</p>
<h4><span style=\"color:#008000\">Concept</span></h4>
<p>Simple test to calculate the heat flux through the different conduction and convection models.</p>
<p>Boundary conditions can be given by 2 different temperatur values on each side of the model. Models with additional inputs (e.g. variable thermal conductivity, wind speed, ...) will be given preferably alternating input values, for example customized sine values.</p>
</html>",   revisions="<html>
<p><ul>
<li><i>April 16, 2013&nbsp;</i> by Ole Odendahl:<br/>Implemented, added documentation and formatted appropriately</li>
</ul></p>
</html>
"),   experiment(StopTime=100, __Dymola_Algorithm="Dassl"),
      __Dymola_experimentSetupOutput);
  end HeatTransfer_test;

  model TimeUtilities_test
    "Simulation to test the utilities concerning the time"
    import Utilities;
    extends Modelica.Icons.Example;
    Sources.NightMode nightMode(dayStart=8, dayEnd=20)
      annotation (Placement(transformation(extent={{-12,-32},{8,-12}})));
    Sources.HourOfDay   hourOfDay
      annotation (Placement(transformation(extent={{-12,10},{8,30}})));
    Modelica.Blocks.Interfaces.BooleanOutput boolNightMode
      annotation (Placement(transformation(extent={{56,-30},{76,-10}})));
    Modelica.Blocks.Interfaces.RealOutput realSamples[1]
      annotation (Placement(transformation(extent={{56,30},{76,50}})));

  equation
    //Connections for real outputs
    realSamples[1] = hourOfDay.HOD;

    //Connection for night mode output
    boolNightMode = nightMode.IsNight.y;

    connect(boolNightMode, boolNightMode) annotation (Line(
        points={{66,-20},{66,-20}},
        color={255,0,255},
        smooth=Smooth.None));
    annotation (experiment(StopTime=604800, Interval=600),
                      __Dymola_experimentSetupOutput,
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
              100,100}}),
                      graphics),
      Documentation(revisions="<html>
<p><ul>
<li><i>April 25, 2013&nbsp;</i> by Ole Odendahl:<br/>Implemented model, added documentation and formatted appropriately</li>
</ul></p>
</html>
", info="<html>
<h4><span style=\"color:#008000\">Overview</span></h4>
<p>Simulation to test the functionality of time concerning models.</p>
<h4><span style=\"color:#008000\">Concept</span></h4>
<p>To check the calculations of models which are using the simulation time. There are no inputs required.</p>
<p>Output values can be easily displayed via the provided output ports, one for each data type (real and boolean).</p>
</html>"));
  end TimeUtilities_test;

end Examples;
