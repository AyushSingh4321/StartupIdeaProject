import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/startup_idea.dart';

class StorageService {
  static const String _ideasKey = 'startup_ideas';
  static const String _votedIdeasKey = 'voted_ideas';

  // Save ideas to local storage
  static Future<void> saveIdeas(List<StartupIdea> ideas) async {
    final prefs = await SharedPreferences.getInstance();
    final ideasJson = ideas.map((idea) => idea.toJson()).toList();
    await prefs.setString(_ideasKey, jsonEncode(ideasJson));
  }

  // Load ideas from local storage
  static Future<List<StartupIdea>> loadIdeas() async {
    final prefs = await SharedPreferences.getInstance();
    final ideasString = prefs.getString(_ideasKey);
    
    if (ideasString == null) return [];
    
    final ideasJson = jsonDecode(ideasString) as List;
    return ideasJson.map((json) => StartupIdea.fromJson(json)).toList();
  }

  // Add a new idea
  static Future<void> addIdea(StartupIdea idea) async {
    final ideas = await loadIdeas();
    ideas.add(idea);
    await saveIdeas(ideas);
  }

  // Update an existing idea
  static Future<void> updateIdea(StartupIdea updatedIdea) async {
    final ideas = await loadIdeas();
    final index = ideas.indexWhere((idea) => idea.id == updatedIdea.id);
    
    if (index != -1) {
      ideas[index] = updatedIdea;
      await saveIdeas(ideas);
    }
  }

  // Check if user has voted for an idea
  static Future<bool> hasVoted(String ideaId) async {
    final prefs = await SharedPreferences.getInstance();
    final votedIds = prefs.getStringList(_votedIdeasKey) ?? [];
    return votedIds.contains(ideaId);
  }

  // Mark idea as voted
  static Future<void> markAsVoted(String ideaId) async {
    final prefs = await SharedPreferences.getInstance();
    final votedIds = prefs.getStringList(_votedIdeasKey) ?? [];
    
    if (!votedIds.contains(ideaId)) {
      votedIds.add(ideaId);
      await prefs.setStringList(_votedIdeasKey, votedIds);
    }
  }

  // Get voted idea IDs
  static Future<List<String>> getVotedIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_votedIdeasKey) ?? [];
  }
}