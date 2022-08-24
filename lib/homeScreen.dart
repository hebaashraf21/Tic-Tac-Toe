import 'package:flutter/material.dart';
import 'package:tic_tac/gameLogic.dart';

class HomeScreen extends StatefulWidget
{
  @override
  Home createState() {
    return Home();
    throw UnimplementedError();
  }
  
}

class Home extends State<HomeScreen>
{
  bool isSwitched=false;
  String activePlayer='X';
  String Result='';
  bool gameOver=false;
  int turn=0;
  Game game=Game();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Theme.of(context).primaryColor,

      body: SafeArea(child: Padding(padding: EdgeInsets.all(10),
      child: Expanded(child:MediaQuery.of(context).orientation == Orientation.portrait
            ? Column(
                children: [
                  ...firstBlock(),
                  _expanded(context),
                  ...lastBlock(),
                ],
              ):Row(
                children: [

                  Expanded(child: Column(
                    children: [
                      ...firstBlock(),
                      ...lastBlock()
                    ],
                  )),
                  _expanded(context),

                ],
              )),),
      
      ),

    );
    throw UnimplementedError();
  }


  List<Widget>lastBlock()
  {
    return [SizedBox(height:12),
          
          Text("$Result",style: TextStyle(fontSize: 30,color: Colors.white),textAlign: TextAlign.center,),

          SizedBox(height:12),

          ElevatedButton.icon(onPressed: (){

           setState(() {
              Player.playerO=[];
            Player.playerX=[];
            activePlayer='X';
            isSwitched=false;
            gameOver=false;
            Result='';
            turn=0;

           });
          },
           icon: Icon(Icons.repeat),
            label: Text("Play again?"),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Theme.of(context).splashColor)
            ),
            ),
            SizedBox(height: 10,)];
  }

  List<Widget>firstBlock()
  {
    return [SizedBox(height: 20,),

          SwitchListTile.adaptive(value:isSwitched , onChanged: (newVal){

            setState(() {
              isSwitched=newVal;
            });
          },
          title: Text("turn on/off two players",style:TextStyle(color: Colors.white,fontSize: 25),textAlign: TextAlign.center,),
          
          ),

          SizedBox(height:10),

          Text("It is $activePlayer turn!".toUpperCase(),style: TextStyle(fontSize: 50,color: Colors.white),textAlign: TextAlign.center,),

          SizedBox(height:10)];

  }

  Widget _expanded(BuildContext context)
  {
    return Expanded(child: GridView.count(crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: List.generate(9, (index) => InkWell(

            borderRadius: BorderRadius.circular(8),

            onTap:gameOver?null: () => _ontap(index),
            child: Container(

              child: Center(child: Text((Player.playerX.contains(index))?"X":(Player.playerO.contains(index))?"O":"",

              style: TextStyle(color: (Player.playerX.contains(index))?Colors.blue:Colors.pink,
              fontSize: 25
              
              ),


              
              ),),
              decoration: BoxDecoration(

                borderRadius: BorderRadius.circular(8),
                color:Theme.of(context).shadowColor,
              ),
            ),




          )),
          
          
          ));
          

  }
  
   _ontap(int index) async {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
      game.playGame(index, activePlayer);
      updateState();

      if (!isSwitched && !gameOver && turn != 9) {
        await game.autoPlay(activePlayer);
        updateState();
      }
    }
  }
  
  void updateState()
  {
    setState(() {
      activePlayer=(activePlayer=='X')?'O':'X';
      turn++;
      String result=game.checkWinner();
      if(result=='X')
      {
        Result='X is the Winner!';
        gameOver=true;

      }
      else if(result=='O')
      {
        Result='O is the Winner!';
        gameOver=true;
      }
      else if(!gameOver&&turn==9)
      {
        Result='It is a Draw!';
      }
      else
      {
        Result='';
      }
    });

  }

}