
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import '../UserState.dart';
import '../models/models.dart';


class ChartsOverview extends StatelessWidget{
  const ChartsOverview({ super.key });

  // To-Do add category and context over Userstate

  // State<StatefulWidget> createState() => PieChartState(category: category, context: context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Charts'),
    ),
      body: ListView(
        children: [
          PieChartState(context: context),
          BarChartWidget(context: context)
        ],

        // To-Do Add Charts
        // maybe like in CategoryOverview
        // PieChartState(
        // ),
        // BarChartState()

      ),
    );
  }
}

class PieChartState extends StatelessWidget{

  // Category category;

  late final BuildContext context;
  late final List<Category> categoryListOverview;

  PieChartState({required this.context}) {
    categoryListOverview = UserState.of(context).categoryList;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(aspectRatio: 1,
        child: PieChart(PieChartData(
            sectionsSpace: 0,
            centerSpaceRadius: 0,
          ///Pass the sections of the pie chart
            sections: section()
        )

        )
        );
  }

  //Method to generate each section for the chart from a catgeory
  List<PieChartSectionData> section() {
    //do i need to return the list
    // like this  return List
    final List<PieChartSectionData> list = [];
    for (var category in categoryListOverview) {
      final data = PieChartSectionData(
        //für jede Kategorie herausfinden wie viele Expensenses in dieser vorhanden ist
        //Value = NumberofExpenses/AllExpenses * 100
        value: 1/categoryListOverview.length*100,
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
        title: category.name,
        /*badgeWidget: Icon(
          // Icon referenzieren,

      ),*/
    // badgePositionPercentageOffset: .98,
        radius: 100,
    );
      list.add(data);

    }
    return list;
  }
}

class Badge extends StatelessWidget {
  const Badge (
      this.icon, {
        size,
        color,
  }
      );

  final String icon;
  final double size = 50.0;
  final Color color = Colors.black;

  @override
  Widget build(BuildContext context){
    // Animated Version of the standart Container
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      // Contains the Icon
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ]
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        /// To-Do change the icon for each category
        /// like this Icon(category.icon)
        child: Icon(Icons.badge),
      ),
    );
  }
}


class BarChartWidget extends StatelessWidget {

  late final BuildContext context;
  late final List<Category> categoryListBarChart;

  BarChartWidget({required this.context}) {
    categoryListBarChart = UserState.of(context).categoryList;
  }
  //x-Achse categories
  //y-Achse budget
  //bekomme ich über category

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: BarChart(
        //Holds the Data needed to draw the BarChart
        BarChartData(
          // Groups the Bars together, to create a Bar Chart
          barGroups: _chartGroups(),
          borderData: FlBorderData(
            border: const Border( top: BorderSide.none, right: BorderSide.none,
              left: BorderSide(width: 1), bottom: BorderSide(width: 1))
          ),
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            // To-do Add Labels for the y and x axis

            bottomTitles: AxisTitles(
              axisNameWidget:  Text('Category', style: TextStyle(color: Colors.black, fontSize: 22),),
                sideTitles: SideTitles(showTitles: true,   getTitlesWidget: bottomTitles)),
            leftTitles: AxisTitles( axisNameWidget:  Text('Budget', style: TextStyle(color: Colors.black, fontSize: 22),),
                sideTitles: SideTitles(showTitles: true, getTitlesWidget: leftTitles)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          )

        )

    ),
    );
  }

  //Get the Values from each Category as bars
  List<BarChartGroupData> _chartGroups() {
    final List<BarChartGroupData> list = [];
    for (var category in categoryListBarChart) {
      BarChartGroupData(
        // To-Do schauen wie man x richtig setzt
          x: categoryListBarChart.indexOf(category)+1,
          barRods: [
            //Specifies the Data of a bar
            BarChartRodData(
              //Position where the Bar Starts from
                fromY: 0,
                // Position to the max value of the bar
                toY: category.budget.toDouble(),
              // better way ist to get the color from the category list
              //In order fro matching colors for pie and bar chart
              color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
            )
          ]
      );

    }
    return list;
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '1K';
    } else if (value == 10) {
      text = '5K';
    } else if (value == 19) {
      text = '10K';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  //get the names for each category
  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
      String text = '';
      //do i need cases
      //when yes
      //switch (value.toInt()) {

      for (var category in categoryListBarChart) {
        text = category.name;
        return Text(text);
      }

      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 0,
        child: Text(text, style: style),
      );

    }
}

