import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:chrome/chrome_ext.dart' as chrome;


List<String> musicList = null;


  
// Explore the tree on a recursive way
void fillMusicList(chrome.BookmarkTreeNode node)
{
  // sleep(new Duration(milliseconds: 200));
  if(node.url == null) // Folder
  {
    chrome.bookmarks.getChildren(node.id).then((List<chrome.BookmarkTreeNode> children) {
      for (chrome.BookmarkTreeNode child in children)
      {
        fillMusicList(child);
      }
    });
  }
  else // Music
  {
    musicList.add(node.url);
    print(node.url);
  }
}

void main() async {
  print("Extention launched");

  print("Loading video");
  musicList = new List();
  
  chrome.BookmarkTreeNode musicFolder = (await chrome.bookmarks.search("Songs")).first;
  fillMusicList(musicFolder);
  
  chrome.browserAction.onClicked.listen((e) {
    print("Click detected");
    
    Random generator = new Random();
    int choiceIndex = generator.nextInt(musicList.length)-1;
    
    chrome.tabs.create(new chrome.TabsCreateParams( 
        url:      musicList[choiceIndex], 
        active:   false));

  });
}
