import 'package:castaway/domain/entity/episode.dart';
import 'package:castaway/presentation/bloc/episode_tile/episode_tile_bloc.dart';
import 'package:castaway/presentation/bloc/episode_tile/episode_tile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EpisodeTile extends StatefulWidget {
  final Episode episode;
  final EpisodeTileBloc bloc;
  final VoidCallback onPlayPressed;
  final VoidCallback onPausePressed;

  const EpisodeTile({
    Key key,
    @required this.episode,
    @required this.bloc,
    @required this.onPlayPressed,
    @required this.onPausePressed,
  }) : super(key: key);

  @override
  _EpisodeTile createState() => _EpisodeTile();
}

class _EpisodeTile extends State<EpisodeTile>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _buildEpisodeTile(context),
    );
  }

  BlocProvider<EpisodeTileBloc> _buildEpisodeTile(BuildContext context) {
    return BlocProvider(
      create: (_) => widget.bloc,
      child: BlocBuilder<EpisodeTileBloc, EpisodeTileState>(
        builder: (context, state) {
          if (state is Empty) {
            return _buildEpisodeRow();
          } else if (state is Buffering) {
            return _buildEpisodeRow();
          } else if (state is Playing) {
            return _buildEpisodeRow();
          } else if (state is Paused) {
            controller.animateTo(0.0);
            return _buildEpisodeRow();
          } else if (state is Error) {
            return _buildEpisodeRow();
          } else {
            return _buildEpisodeRow();
          }
        },
      ),
    );
  }

  Widget _buildEpisodeRow() {
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: <Widget>[
                Text(
                  '25',
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                Text(
                  'Jan',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: 11),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15.0, 14.0, 0.0, 14.0),
              width: 2.0,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Theme.of(context).accentColor,
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(40.0),
                    topRight: const Radius.circular(40.0),
                    bottomLeft: const Radius.circular(40.0),
                    bottomRight: const Radius.circular(40.0),
                  )),
            )
          ],
        ),
        title: Text(
          widget.episode.title,
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
        ),
        subtitle: Text("Subtitle",
            style: TextStyle(color: Theme.of(context).accentColor)),
        dense: false,
        trailing: IconButton(
          icon: AnimatedIcon(
            icon: AnimatedIcons.play_pause,
            progress: controller,
          ),
          onPressed: () {
            if (widget.bloc.state is Playing) {
              controller.reverse();
              widget.onPausePressed();
            } else {
              controller.forward();
              widget.onPlayPressed();
            }
          },
        ),
      ),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black26))),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
