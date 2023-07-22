
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import '../UserState.dart';
import '../models/models.dart';


class ChartsOverview extends StatelessWidget{
  const ChartsOverview({ super.key });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Charts'),
    ),
      body: ListView(
        children: [
          /// To-Do add nested Listview for each Chart
          /// scrollDirection: Axis.horizontal
          PieChartState(context: context),
          Padding(
            padding: EdgeInsets.all(16.0),
          ),
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

  final List<Color> colors = <Color>[Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.orange,
    Colors.lime, Colors.purple, Colors.teal, Colors.indigoAccent, Colors.pink,
    Colors.pinkAccent, Colors.purpleAccent, Colors.amber, Colors.deepOrange, Colors.cyan,
    Colors.grey, Colors.green.shade900, Colors.red.shade900, Colors.lime.shade800, Colors.indigo.shade400,
    Colors.teal.shade400, Colors.orangeAccent, Colors.blue.shade900, Colors.lightGreen.shade100, Colors.purpleAccent.shade700,
    Colors.greenAccent, Colors.lightBlueAccent.shade200, Colors.deepPurple.shade200, Colors.pinkAccent.shade200, Colors.yellow.shade200];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1.3,
        child: Row(
        children: <Widget>[
        const SizedBox(
        height: 18,
    ),
      AspectRatio(aspectRatio: 1,
        child: PieChart(PieChartData(
            sectionsSpace: 0,
            centerSpaceRadius: 0,
          ///Pass the sections of the pie chart
            sections: section()
        ),

        ),
      /// Show a legend under the PieChart
      ),
          Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
          children: <Widget>[
            Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
            ),
          ),
            SizedBox(
              width: 4,
            ),
            Text(
              'Text',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).iconTheme.color,
              ),
            )
          ],
                )
              ]

          )
        ],

      ),
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
        ///maybe add a list of colors
        ///the color is different from index to index
        /// x: categoryListOverview.indexOf(category)+1 == 1 is green,

        /// List of Pastel Colors
        // color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
        color: colors[categoryListOverview.indexOf(category)],
        // title: category.name,
        title: (1/categoryListOverview.length*100).toStringAsFixed(2) + '%',
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

  final List<Color> colors = <Color>[Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.orange,
    Colors.lime, Colors.purple, Colors.teal, Colors.indigoAccent, Colors.pink,
    Colors.pinkAccent, Colors.purpleAccent, Colors.amber, Colors.deepOrange, Colors.cyan,
    Colors.grey, Colors.green.shade900, Colors.red.shade900, Colors.lime.shade800, Colors.indigo.shade400,
    Colors.teal.shade400, Colors.orangeAccent, Colors.blue.shade900, Colors.lightGreen.shade100, Colors.purpleAccent.shade700,
    Colors.greenAccent, Colors.lightBlueAccent.shade200, Colors.deepPurple.shade200, Colors.pinkAccent.shade200, Colors.yellow.shade200];


  //x-Achse categories
  //y-Achse budget
  //bekomme ich über category

  @override
  Widget build(BuildContext context) {
    /// rounded Borders
    return Container (
      // color: Theme.of(context).iconTheme.color,
        child: AspectRatio(
      aspectRatio: 2,
      child: BarChart(
        //Holds the Data needed to draw the BarChart
        BarChartData(
          // Groups the Bars together, to create a Bar Chart
          barGroups: _chartGroups(),
            barTouchData: barTouchData,
          borderData: FlBorderData(
            border: const Border( top: BorderSide.none, right: BorderSide.none,
              left: BorderSide(width: 1), bottom: BorderSide(width: 1))
          ),
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            // To-do Add Labels for the y and x axis

            bottomTitles: AxisTitles(
              axisNameWidget:  Text('Category', style: TextStyle(color: Colors.black, fontSize: 14),),
                sideTitles: SideTitles(showTitles: true,   getTitlesWidget: bottomTitles)),
            leftTitles: AxisTitles( axisNameWidget:  Text('Budget', style: TextStyle(color: Colors.black, fontSize: 14),),
                sideTitles: SideTitles(showTitles: true, getTitlesWidget: leftTitles)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          )

        )

    ),
        ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      tooltipBgColor: Colors.transparent,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 8,
      getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
          ) {
        return BarTooltipItem(
          rod.toY.round().toStringAsFixed(0) + '€',
          TextStyle(
            color: colors[categoryListBarChart.indexOf(category)],
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  );

  //Get the Values from each Category as bars
  List<BarChartGroupData> _chartGroups() {
    final List<BarChartGroupData> list = [];
    for (var category in categoryListBarChart) {
      final data = BarChartGroupData(
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
              color: colors[categoryListBarChart.indexOf(category)],
              width: 8,
            )
          ],
        showingTooltipIndicators: [0],
      );
      list.add(data);
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

