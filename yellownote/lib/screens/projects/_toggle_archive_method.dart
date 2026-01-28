  Future<void> _toggleArchive(BuildContext context) async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final updatedProject = widget.project.copyWith(
      isArchived: !widget.project.isArchived,
    );
    await dataProvider.updateProject(updatedProject);
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.project.isArchived 
            ? 'Projekt przywrócony z archiwum' 
            : 'Projekt zarchiwizowany'),
          backgroundColor: AppColors.yellow,
        ),
      );
      Navigator.pop(context);
    }
  }
