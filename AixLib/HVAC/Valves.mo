within AixLib.HVAC;
package Valves "Models for valves"
  extends Modelica.Icons.Package;
  model SimpleValve
    extends AixLib.HVAC.Interfaces.TwoPort;

    parameter Real Kvs = 1.4 "Kv value at full opening (=1)";

    Modelica.Blocks.Interfaces.RealInput opening "valve opening" annotation (
        Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={0,80})));

  equation
   // Enthalpie flow
    port_a.h_outflow = inStream(port_b.h_outflow);
    port_b.h_outflow = inStream(port_a.h_outflow);

    //Calculate the pressure drop

    //m_flow = rho * 1/3600 * Kvs * opening * sqrt(p / 100000);    //This is educational purposes equatioan, can be used to show the functionality of a valve when the flow direction is correct

      m_flow = rho * 1/3600 * Kvs * opening * Modelica.Fluid.Utilities.regRoot2(p,Modelica.Constants.small,1e-4, 1e-4);    //This equation is better suited for stable simulations as it works for both flow directions and is continuous at flow zero

    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
              {100,100}}), graphics={Polygon(
            points={{-78,50},{-78,-60},{82,50},{82,-62},{-78,50}},
            lineThickness=1,
            smooth=Smooth.None,
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None,
            lineColor={0,0,0})}), Diagram(graphics),
      Documentation(revisions="<html>
<p>13.11.2013, by <i>Ana Constantin</i>: implemented</p>
</html>", info="<html>
<h4><span style=\"color:#008000\">Overview</span></h4>
<p>Model for a simple valve. </p>
<h4><span style=\"color:#008000\">Level of Development</span></h4>
<p><img src=\"modelica://AixLib/Images/stars3.png\"/></p>
<h4><span style=\"color:#008000\">Concept</span></h4>
<p>Simple valve model which describes the relationship between mass flow and pressure drop acoordinh to the Kvs Value.</p>
<h4><span style=\"color:#008000\">Example Results</span></h4>
<p><a href=\"AixLib.HVAC.Radiators.Examples.PumpRadiatorValve\">AixLib.HVAC.Radiators.Examples.PumpRadiatorValve</a></p>
</html>"));
  end SimpleValve;

  model ThermostaticValve
    extends AixLib.HVAC.Interfaces.TwoPort;

    parameter Real Kvs = 1.4 "Kv value at full opening (=1)" annotation (Dialog(group = "Valve"));
    parameter Real Kv_setT = 0.8
      "Kv value when set temperature = measured temperature" annotation (Dialog(group = "Thermostatic head"));
    parameter Real P = 2 "Deviation of P-controller when valve is closed" annotation (Dialog(group = "Thermostatic head"));
    parameter Real Influence_PressureDrop = 0.14
      "influence of the pressure drop in K" annotation (Dialog(group = "Thermostatic head"));
    parameter Real leakageOpening = 0.0001
      "may be useful for simulation stability. Always check the influence it has on your results";

    //Variable
    Real opening "valve opening";
    Real TempDiff "Difference between measured temperature and set temperature";
    Real Influence_PressureDrop_inK "Influence of pressure drop in Kelvin.";

    Modelica.Blocks.Interfaces.RealInput T_room "temperature in room"
                                                                 annotation (
        Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={-64,98})));
    Modelica.Blocks.Interfaces.RealInput T_setRoom "set temperature in room"
                                                                 annotation (
        Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={56,98})));
  equation
   // Enthalpie flow
    port_a.h_outflow = inStream(port_b.h_outflow);
    port_b.h_outflow = inStream(port_a.h_outflow);

    //Calculate the pressure drop
    m_flow = rho * 1/3600 * Kvs * opening * Modelica.Fluid.Utilities.regRoot2(p,Modelica.Constants.small,1e-4, 1e-4);  //original equation valve

    //calculate the influence of the pressure drop
    Influence_PressureDrop_inK = Influence_PressureDrop*(p / 100000 - 0.1)/0.5;

    //calculate the measured temperature difference
    TempDiff = T_room - T_setRoom - Influence_PressureDrop_inK;

    //Calculating the valve opening depending on the temperature deviation
    if TempDiff > P then
       opening = leakageOpening;
    else
      opening = min(1, (P-TempDiff)*(Kv_setT/Kvs)/P);
    end if;

    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
              {100,100}}), graphics={Polygon(
            points={{-78,50},{-78,-60},{82,50},{82,-62},{-78,50}},
            lineThickness=1,
            smooth=Smooth.None,
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None,
            lineColor={0,0,0})}), Diagram(coordinateSystem(preserveAspectRatio=false,
            extent={{-100,-100},{100,100}}), graphics),
      Documentation(revisions="<html>
<p>13.11.2013, by <i>Ana Constantin</i>: implemented</p>
</html>", info="<html>
<h4><span style=\"color:#008000\">Overview</span></h4>
<p>Model for a simple thermostatic valve.</p>
<h4><span style=\"color:#008000\">Level of Development</span></h4>
<p><img src=\"modelica://AixLib/Images/stars3.png\"/></p>
<h4><span style=\"color:#008000\">Concept</span></h4>
<p>Development of SimpleValve by incorporating the behaviour of a thermostatic head as a P controller with a maximum deviation of <i>P</i> and an influence of the pressure drop on the sensed temperature.</p>
<p>It is possible to not close the valve completely by allowing for some minimal leakage. Use this option carefully and always check&nbsp;the&nbsp;influence&nbsp;it&nbsp;might have on&nbsp;your&nbsp;results. </p>
<h4><span style=\"color:#008000\">Example Results</span></h4>
<p><a href=\"AixLib.HVAC.Radiators.Examples.PumpRadiatorThermostaticValve\">AixLib.HVAC.Radiators.Examples.PumpRadiatorThermostaticValve</a></p>
</html>"));
  end ThermostaticValve;
end Valves;
