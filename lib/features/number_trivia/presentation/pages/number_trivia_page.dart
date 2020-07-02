import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:learning/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: buildBody(context),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                    builder: (context, state) {
                  if (state is Empty) {
                    return MessageDisplay(
                      message: 'Start Searching!!',
                    );
                  }
                  if (state is Error) {
                    return MessageDisplay(
                      message: state.message,
                    );
                  }
                  if (state is Loading) {
                    return MessageDisplay(
                      message: 'Loading!!',
                    );
                  }
                  if (state is Loaded) {
                    return MessageDisplay(
                      message: state.trivia.text,
                    );
                  }
                  return Container(
                    height: MediaQuery.of(context).size.height / 2.0,
                    child: Placeholder(),
                  );
                }),
              ),
              SizedBox(
                height: 10,
              ),
              // buttom half
              TriviaControls(),
            ],
          ),
        ),
      ),
    );
  }
}

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key key,
  }) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  String _inputString;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: 'Input a number'),
          onChanged: (value) {
            _inputString = value;
          },
          onSubmitted: (_) {},
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 60,
          child: Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  child: Text('Get Random Trivia'),
                  onPressed: dispatchRandom,
                  elevation: 10,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: RaisedButton(
                  child: Text('Search'),
                  color: Theme.of(context).accentColor,
                  onPressed: dispatchConcrete,
                  elevation: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void dispatchConcrete() {
    log('data: $_inputString');
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(numberString: _inputString));
  }

  void dispatchRandom() {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}

class MessageDisplay extends StatelessWidget {
  final String message;

  const MessageDisplay({
    Key key,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.0,
      child: Center(
        child: Text(
          message,
          style: TextStyle(fontSize: 24.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
