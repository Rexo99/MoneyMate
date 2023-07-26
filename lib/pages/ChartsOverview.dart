import 'package:flutter/material.dart';
import 'package:money_mate/models/ExpenseList.dart';
import '../util/StateManagement.dart';
import 'package:fl_chart/fl_chart.dart';
import '../UserState.dart';
import '../models/models.dart';
import '../util/HTTPRequestBuilder.dart';


/// Visualizes the Expense Data as Charts
///
/// Code by Daniel Ottolien
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
          PieChartState(context: context),
          Padding(
            padding: EdgeInsets.all(16.0),
          ),
          BarChartWidget(context: context)
        ],

      ),
    );
  }
}

///Visualizes the Expense data as a PieChart
class PieChartState extends StatelessWidget{

  late final BuildContext context;
  late final List<Category> categoryListOverview;
  late final ExpenseList categoryExpenseList;

  PieChartState({required this.context}) {
    categoryListOverview = UserState.of(context).categoryList;
    categoryExpenseList = UserState.of(context).expendList;
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
                sections: section()
            ),
            ),
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: []
          )
        ],
      ),
    );
  }

  /// Method to get the SectionData for each expenses of each category
  List<int> expenseSectionData() {
    final List<int> pielist = [];
    int expensevalue = 0;
    for (var category in categoryListOverview) {
      /// This code loops in the other for loop
      int expensecounter = 0;
      for (Prop<Expense> expense in categoryExpenseList.value) {
        if ( expense.value.categoryId == category.id) {
          expensecounter += 1;
        }
      }
      expensevalue = expensecounter;
      pielist.add(expensevalue);
    }
    return pielist;
  }


  /// Method to generate each section for the chart
  List<PieChartSectionData> section() {
    final List<PieChartSectionData> list = [];
    final List<int> pielist = expenseSectionData();
    for (var category in categoryListOverview) {
      final data = PieChartSectionData(
        value: pielist[categoryListOverview.indexOf(category)]/categoryExpenseList.value.length*100,
        color: colors[categoryListOverview.indexOf(category)],
        title: (pielist[categoryListOverview.indexOf(category)]/categoryExpenseList.value.length*100).toStringAsFixed(2) + '%',
        radius: 100,
      );
      list.add(data);
    }
    return list;
  }
}


class ChartElement extends StatelessWidget {
  Category category;

  ChartElement({required this.category, super.key});

  final List<Color> colors = <Color>[Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.orange,
    Colors.lime, Colors.purple, Colors.teal, Colors.indigoAccent, Colors.pink,
    Colors.pinkAccent, Colors.purpleAccent, Colors.amber, Colors.deepOrange, Colors.cyan,
    Colors.grey, Colors.green.shade900, Colors.red.shade900, Colors.lime.shade800, Colors.indigo.shade400,
    Colors.teal.shade400, Colors.orangeAccent, Colors.blue.shade900, Colors.lightGreen.shade100, Colors.purpleAccent.shade700,
    Colors.greenAccent, Colors.lightBlueAccent.shade200, Colors.deepPurple.shade200, Colors.pinkAccent.shade200, Colors.yellow.shade200];


  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.red
          ),
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          category.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).iconTheme.color,
          ),
        ),

      ],
    );
  }
}


class ChartLegend extends StatelessWidget {

  late final BuildContext context;
  late final List<Category> categoryListOverview;

  ChartLegend({required this.context}) {
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
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      itemCount: categoryListOverview.length,
      itemBuilder: (BuildContext context, int index) {
        var cats = categoryListOverview[index];
        return ChartElement(category: cats);
      },
      // separatorBuilder: (BuildContext context, int index) =>
      // const Divider(),
    );
  }
}

/// Visualizes the Expense Data as a Bar Chart
class BarChartWidget extends StatelessWidget {

  late final BuildContext context;
  late final List<Category> categoryListBarChart;
  late final ExpenseList categoryExpenseBarList;


  BarChartWidget({required this.context}) {
    categoryListBarChart = UserState.of(context).categoryList;
    categoryExpenseBarList = UserState.of(context).expendList;
  }

  final List<Color> colors = <Color>[Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.orange,
    Colors.lime, Colors.purple, Colors.teal, Colors.indigoAccent, Colors.pink,
    Colors.pinkAccent, Colors.purpleAccent, Colors.amber, Colors.deepOrange, Colors.cyan,
    Colors.grey, Colors.green.shade900, Colors.red.shade900, Colors.lime.shade800, Colors.indigo.shade400,
    Colors.teal.shade400, Colors.orangeAccent, Colors.blue.shade900, Colors.lightGreen.shade100, Colors.purpleAccent.shade700,
    Colors.greenAccent, Colors.lightBlueAccent.shade200, Colors.deepPurple.shade200, Colors.pinkAccent.shade200, Colors.yellow.shade200];

  ///Method to get the Rod data
  List<int> expenseBarData() {
    final List<int> barlist = [];
    int expensevalue = 0;
    for (var category in categoryListBarChart) {
      /// This code loops in the other for loop
      int expensebudget = 0;
      for (Prop<Expense> expense in categoryExpenseBarList.value) {
        if ( expense.value.categoryId == category.id) {
          expensebudget += expense.value.amount.toInt();
        }
      }
      expensevalue = expensebudget;
      barlist.add(expensevalue);
    }
    return barlist;
  }


  @override
  Widget build(BuildContext context) {
    return Container (
      child: AspectRatio(
        aspectRatio: 2,
        child: BarChart(
            BarChartData(
                barGroups: _chartGroups(),
                barTouchData: barTouchData,
                borderData: FlBorderData(
                    border: const Border( top: BorderSide.none, right: BorderSide.none,
                        left: BorderSide(width: 1), bottom: BorderSide(width: 1))
                ),
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                      axisNameWidget:  Text('Category', style: TextStyle(color: Theme.of(context).iconTheme.color, fontSize: 14),),
                      sideTitles: SideTitles(showTitles: true,   getTitlesWidget: bottomTitles)),
                  leftTitles: AxisTitles( axisNameWidget:  Text('Budget', style: TextStyle(color: Theme.of(context).iconTheme.color, fontSize: 14),),
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
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  );

  /// Get the Values from teh spent Budget in each Category and visualizes it as a bar
  List<BarChartGroupData> _chartGroups() {
    final List<BarChartGroupData> list = [];
    final List<int> barlist = expenseBarData();
    for (var category in categoryListBarChart) {
      final data = BarChartGroupData(
        x: categoryListBarChart.indexOf(category)+1,
        barRods: [
          /// Specifies the Data of a bar
          BarChartRodData(
            /// Position where the Bar Starts from
            fromY: 0,
            /// Position to the max value of the bar
            toY: barlist[categoryListBarChart.indexOf(category)].toDouble(),
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

  List<String> barName() {
    final List<String> list = [];
    list.add('hello');
    for (var category in categoryListBarChart) {
      String cat = category.name;
      list.add(cat);
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
      text = '0€';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  /// get the names for each category
  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = barName();
    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 0, //margin top
        // child: RotatedBox(quarterTurns: -1, child: text),
        child: text
    );
  }
}

