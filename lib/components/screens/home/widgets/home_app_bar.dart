import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar();

  static double height(double topPadding) =>
      topPadding + kToolbarHeight + HomeTabBar.height;

  List<Widget> _buildActions(
    BuildContext context,
    ThemeData theme,
    TimelineFilterModel model,
    HomeTimelineBloc bloc,
  ) {
    return [
      HarpyButton.flat(
        padding: const EdgeInsets.all(16),
        icon: bloc.state.enableFilter &&
                bloc.state.timelineFilter != TimelineFilter.empty
            ? Icon(Icons.filter_alt, color: theme.colorScheme.secondary)
            : const Icon(Icons.filter_alt_outlined),
        onTap:
            bloc.state.enableFilter ? Scaffold.of(context).openEndDrawer : null,
      ),
      CustomPopupMenuButton<int>(
        icon: const Icon(Icons.more_vert),
        onSelected: (selection) {
          if (selection == 0) {
            ScrollDirection.of(context)!.reset();

            bloc.add(const RefreshHomeTimeline(clearPrevious: true));
          }
        },
        itemBuilder: (context) {
          return <PopupMenuEntry<int>>[
            const HarpyPopupMenuItem<int>(
              value: 0,
              text: Text('refresh'),
            ),
          ];
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scrollDirection = ScrollDirection.of(context)!;

    final model = context.watch<TimelineFilterModel>();
    final bloc = context.watch<HomeTimelineBloc>();

    // since the sliver app bar does not work as intended with the nested
    // scroll view in the home tab view, we use an animated shifted position
    // widget and animate the app bar out of the view based on the scroll
    // position to manually hide / show the app bar
    return AnimatedShiftedPosition(
      shift: scrollDirection.direction == VerticalDirection.down
          ? const Offset(0, -1)
          : Offset.zero,
      child: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          HarpySliverAppBar(
            title: 'Harpy',
            showIcon: true,
            floating: true,
            snap: true,
            actions: _buildActions(context, theme, model, bloc),
            bottom: const HomeTabBar(),
          ),
        ],
      ),
    );
  }
}
