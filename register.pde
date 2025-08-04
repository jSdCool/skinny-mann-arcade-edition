//start of register.pde
/**Register all things from the base game that need to be registerd to the various registries
*/
void registerThings(){
  //Stage components
  StageComponentRegistry.register(Ground.ID, Ground::new,  Ground::new, Ground::new, (render, x, y) -> {
    render.fill(-7254783);
    render.stroke(-7254783);
    render.rect(x, y+30, 50, 20);
    render.fill(-16732415);
    render.stroke(-16732415);
    render.rect(x, y+20, 50, 10);
  }, "Ground", new Boolean[]{true,true}, (render, x, y, dx, dy, color_, rotation, scale)->{
    render.fill(color_);
    render.rect(x,y,dx,dy);
  });
  StageComponentRegistry.register(Holo.ID,Holo::new,Holo::new,Holo::new, (render, x, y) -> {}, "Holo", new Boolean[]{true,true}, (render, x, y, dx, dy, color_, rotation, scale)->{
    render.fill(color_);
    render.rect(x,y,dx,dy);
  });
  StageComponentRegistry.register(Sloap.ID,Sloap::new,Sloap::new,Sloap::new, (render, x, y) -> {
    render.fill(-7254783);
    render.stroke(-7254783);
    render.strokeWeight(0);
    render.triangle(x+5, y+45, x+45, y+45, x+45, y+5);
  }, "Sloap", new Boolean[]{true,true}, (render, x, y, dx, dy, color_, rotation, scale)->{
    render.fill(color_);
    if (rotation==0) {//display the triangle that will be created
      render.triangle(x, y, dx, dy, dx, y);
    }
    if (rotation==1) {
      render.triangle(x, y, x, dy, dx, y);
    }
    if (rotation==2) {
      render.triangle(x, y, dx, dy, x, dy);
    }
    if (rotation==3) {
      render.triangle(x, dy, dx, dy, dx, y);
    }
  });
  StageComponentRegistry.register(HoloTriangle.ID,HoloTriangle::new,HoloTriangle::new,HoloTriangle::new, (render, x, y) -> {
    render.fill(-4623063);
    render.stroke(-4623063);
    render.strokeWeight(0);
    render.triangle(x+5, y+45, x+45, y+45, x+45, y+5);
  }, "Holo Sloap", new Boolean[]{true,true}, (render, x, y, dx, dy, color_, rotation, scale)->{
    render.fill(color_);
    if (rotation==0) {//display the triangle that will be created
      render.triangle(x, y, dx, dy, dx, y);
    }
    if (rotation==1) {
      render.triangle(x, y, x, dy, dx, y);
    }
    if (rotation==2) {
      render.triangle(x, y, dx, dy, x, dy);
    }
    if (rotation==3) {
      render.triangle(x, dy, dx, dy, dx, y);
    }
  });
  StageComponentRegistry.register(DethPlane.ID,DethPlane::new,DethPlane::new,DethPlane::new, (render, x, y) -> {
    render.fill(-114431);
    render.stroke(-114431);
    render.rect(x+5, y+25, 40, 20);
  }, "Death Plane", new Boolean[]{true,false}, (render, x, y, dx, dy, color_, rotation, scale)->{
    render.fill(-114431);
    render.rect(x,y,dx,dy);
  });
  StageComponentRegistry.register(CheckPoint.ID,CheckPoint::new,CheckPoint::new,CheckPoint::new, (render, x, y) -> {
    render.fill(#B9B9B9);
    render.strokeWeight(0);
    render.rect(x+8, y+5, 5, 40);
    render.fill(#EA0202);
    render.stroke(#EA0202);
    render.strokeWeight(0);
    render.triangle(x+10, y+5, x+10, y+25, x+40,y+15);
    render.strokeWeight(0);
  }, "Check Point", new Boolean[]{true,true},(render, x, y, scale)->{
    drawCheckPoint(x,y,scale,render);
  });
  StageComponentRegistry.register(Coin.ID,Coin::new,Coin::new,Coin::new, (render, x, y) -> {
    drawCoin(x+25, y+25, 4,render);
  }, "Coin", new Boolean[]{true,true},(render, x, y, scale)->{
    drawCoin(x*scale,y*scale,3*scale,render);
  });
  StageComponentRegistry.register(Goal.ID,Goal::new,Goal::new,Goal::new, (render, x, y) -> {
    render.fill(0);
    render.stroke(0);
    render.strokeWeight(0);
    render.rect(x+3, y+3, 15, 15);
    render.rect(x+33, y+3, 15, 15);
    render.rect(x+18, y+18, 15, 15);
    render.rect(x+3, y+33, 15, 15);
    render.rect(x+33, y+33, 15, 15);
  }, "Goal", new Boolean[]{true,false,false,false},(render, x, y, scale)->{
    x*=scale;
    y*=scale;
    render.fill(255);
    render.rect(x, (y), 50, 50);
    render.rect((x+100), (y), 50, 50);
    render.rect((x+200), (y), 50, 50);
    render.fill(0);
    render.rect((x+50), (y), 50, 50);
    render.rect((x+150), (y), 50, 50);
  });
  StageComponentRegistry.register(Interdimentional_Portal.ID,Interdimentional_Portal::new,Interdimentional_Portal::new,null, (render, x, y) -> {
    drawPortal(x+25, y+25, 0.45,render);
  }, "Portal", new Boolean[]{true,true,false,false},(render, x, y, scale)->{});
  StageComponentRegistry.register(LogicButton.ID,LogicButton::new,LogicButton::new,LogicButton::new, (render, x, y) -> {
    drawLogicButton(x+25, y+25, 1, false,render);
  }, "Button", new Boolean[]{true,true,true,false},(render, x, y, scale)->{
    drawLogicButton(x*scale,y*scale,scale,false,render);
  });
  StageComponentRegistry.register(SoundBox.ID,SoundBox::new,SoundBox::new,SoundBox::new, (render, x, y) -> {
    drawSpeakericon(x+25, y+25, 0.5,render);
  }, "Sound Box", new Boolean[]{true,false,true,false},(render, x, y, scale)->{
    drawSoundBox(x*scale,y*scale,scale,render);
  });
  StageComponentRegistry.register(WritableSign.ID,WritableSign::new,WritableSign::new,WritableSign::new, (render, x, y) -> {
    drawSign(x+25, y+50, 0.6,render);
  }, "Sign", new Boolean[]{true,true},(render, x, y, scale)->{
    drawSign(x*scale,y*scale,scale,render);
  });
  StageComponentRegistry.register(SWoff3D.ID,SWoff3D::new,SWoff3D::new,SWoff3D::new,(render, x, y) -> {
    draw3DSwitch2(x+25, y+40, 1,render);
  }, "3D off switch", new Boolean[]{false,true},(render, x, y, scale)->{
    draw3DSwitch2(x,y,scale,render);
  });
  StageComponentRegistry.register(SWon3D.ID,SWon3D::new,SWon3D::new,SWon3D::new,(render, x, y) -> {
    draw3DSwitch1(x+25, y+40, 1,render);
  }, "3D on switch", new Boolean[]{false,true},(render, x, y, scale)->{
    draw3DSwitch1(x,y,scale,render);
  });
  
  SerialRegistry.register(GenericStageComponent.ID,GenericStageComponent::new);//palce
  
  //Logic components
  LogicComponentRegistry.register(AndGate.ID,AndGate::new,AndGate::new,AndGate::new,(render,x,y)->{
    render.fill(147,190,242);
    render.beginShape();
    render.vertex(x+10,y+10);
    render.vertex(x+25,y+10);
    render.bezierVertex(x+25,y+10,x+40,y+10,x+40,y+25);
    render.bezierVertex(x+40,y+25,x+40,y+40,x+24,y+40);
    render.vertex(x+10,y+40);
    render.endShape(CLOSE);
  },"And Gate");
  LogicComponentRegistry.register(OrGate.ID,OrGate::new,OrGate::new,OrGate::new,(render,x,y)->{
    render.fill(147,190,242);
    render.beginShape();
    render.vertex(x+10,y+10);
    render.vertex(x+25,y+10);
    render.bezierVertex(x+25,y+10,x+40,y+10,x+40,y+25);
    render.bezierVertex(x+40,y+25,x+40,y+40,x+24,y+40);
    render.vertex(x+10,y+40);
    render.bezierVertex(x+10,y+40,x+20,y+25,x+10,y+10);
    render.endShape(CLOSE);
  },"Or Gate");
  LogicComponentRegistry.register(XorGate.ID,XorGate::new,XorGate::new,XorGate::new,(render,x,y)->{
    render.fill(147,190,242);
    render.beginShape();
    render.vertex(x+10,y+10);
    render.vertex(x+25,y+10);
    render.bezierVertex(x+25,y+10,x+40,y+10,x+40,y+25);
    render.bezierVertex(x+40,y+25,x+40,y+40,x+24,y+40);
    render.vertex(x+10,y+40);
    render.bezierVertex(x+10,y+40,x+20,y+25,x+10,y+10);
    render.endShape(CLOSE);
    render.beginShape();
    render.vertex(x+3,y+10);
    render.vertex(x+7,y+10);
    render.bezierVertex(x+7,y+10,x+17,y+25,x+7,y+40);
    render.vertex(x+3,y+40);
    render.bezierVertex(x+3,y+40,x+13,y+25,x+3,y+10);
    render.endShape();
  },"Xor Gate");
  LogicComponentRegistry.register(NAndGate.ID,NAndGate::new,NAndGate::new,NAndGate::new,(render,x,y)->{
    render.fill(147,190,242);
    render.beginShape();
    render.vertex(x+10,y+10);
    render.vertex(x+25,y+10);
    render.bezierVertex(x+25,y+10,x+40,y+10,x+40,y+25);
    render.bezierVertex(x+40,y+25,x+40,y+40,x+24,y+40);
    render.vertex(x+10,y+40);
    render.endShape(CLOSE);
    render.circle(x+43.5,y+25,7);
  },"NAnd Gate");
  LogicComponentRegistry.register(NOrGate.ID,NOrGate::new,NOrGate::new,NOrGate::new,(render,x,y)->{
     render.fill(147,190,242);
     render.beginShape();
     render.vertex(x+10,y+10);
     render.vertex(x+25,y+10);
     render.bezierVertex(x+25,y+10,x+40,y+10,x+40,y+25);
     render.bezierVertex(x+40,y+25,x+40,y+40,x+24,y+40);
     render.vertex(x+10,y+40);
     render.bezierVertex(x+10,y+40,x+20,y+25,x+10,y+10);
     render.endShape(CLOSE);
     render.circle(x+43.5,y+25,7);
  },"NOr Gate");
  LogicComponentRegistry.register(XNorGate.ID,XNorGate::new,XNorGate::new,XNorGate::new,(render,x,y)->{
    render.fill(147,190,242);
    render.beginShape();
    render.vertex(x+10,y+10);
    render.vertex(x+25,y+10);
    render.bezierVertex(x+25,y+10,x+40,y+10,x+40,y+25);
    render.bezierVertex(x+40,y+25,x+40,y+40,x+24,y+40);
    render.vertex(x+10,y+40);
    render.bezierVertex(x+10,y+40,x+20,y+25,x+10,y+10);
    render.endShape(CLOSE);
    render.beginShape();
    render.vertex(x+3,y+10);
    render.vertex(x+7,y+10);
    render.bezierVertex(x+7,y+10,x+17,y+25,x+7,y+40);
    render.vertex(x+3,y+40);
    render.bezierVertex(x+3,y+40,x+13,y+25,x+3,y+10);
    render.endShape();
    render.circle(x+43.5,y+25,7);
  },"XNor Gate");
  LogicComponentRegistry.register(Random.ID,Random::new,Random::new,Random::new,(render,x,y)->{
    render.fill(147,190,242);
    render.rect(x+5,y+5,40,40);
    render.fill(87,130,202);
    render.circle(x+15,y+15,10);
    render.circle(x+35,y+15,10);
    render.circle(x+25,y+25,10);
    render.circle(x+15,y+35,10);
    render.circle(x+35,y+35,10);
  },"Random");
  LogicComponentRegistry.register(Delay.ID,Delay::new,Delay::new,Delay::new,(render,x,y)->{
    render.fill(147,190,242);
    render.beginShape();
    render.vertex(x+15,y+10);
    render.vertex(x+35,y+10);
    render.vertex(x+15,y+40);
    render.vertex(x+35,y+40);
    render.endShape(CLOSE);
    render.fill(110);
    render.circle(x+20,y+38,3);
    render.circle(x+25,y+38,3);
    render.circle(x+30,y+38,3);
    render.circle(x+22.5,y+35,3);
    render.circle(x+27.5,y+35,3);
    render.circle(x+25,y+32,3);
    render.circle(x+25,y+22,3);
  },"Delay");
  LogicComponentRegistry.register(Pulse.ID,Pulse::new,Pulse::new,Pulse::new,(render,x,y)->{
    render.fill(0);
    render.rect(x,y+40,20,5);
    render.rect(x+20,y+10,5,35);
    render.rect(x+25,y+10,5,5);
    render.rect(x+30,y+10,5,35);
    render.rect(x+35,y+40,15,5); 
  },"Pulse");
  LogicComponentRegistry.register(ConstantOnSignal.ID,ConstantOnSignal::new,ConstantOnSignal::new,ConstantOnSignal::new,(render,x,y)->{
    render.fill(-369706);
    render.circle(x+10,y+25,20);
    render.fill(255,0,0);
    render.rect(x+10,y+22.5,40,5);
  },"Constant On signal");
  LogicComponentRegistry.register(GenericLogicComponent.ID,GenericLogicComponent::new,GenericLogicComponent::new,GenericLogicComponent::new,(render,x,y)->{},"Generic");
  LogicComponentRegistry.register(LogicPlaySound.ID,LogicPlaySound::new,LogicPlaySound::new,LogicPlaySound::new,(render,x,y)->{
    drawSpeakericon(x+25,y+25,0.5,render);
  },"Play Sound");
  LogicComponentRegistry.register(Read3DMode.ID,Read3DMode::new,Read3DMode::new,Read3DMode::new,(render,x,y)->{
    render.fill(255,0,0);
    render.textAlign(CENTER,CENTER);
    render.textSize(30);
    render.text("3",x+10,y+25);
    render.fill(0,0,255);
    render.text("D",x+23,y+25);
    render.fill(0);
    render.rect(x+33,y+22.5,7,5);
    render.triangle(x+40,y+20,x+50,y+25,x+40,y+31); 
  },"Read 3D");
  LogicComponentRegistry.register(Set3DMode.ID,Set3DMode::new,Set3DMode::new,Set3DMode::new,(render,x,y)->{
    render.fill(255,0,0);
    render.textAlign(CENTER,CENTER);
    render.textSize(30);
    render.text("3",x+25,y+25);
    render.fill(0,0,255);
    render.text("D",x+38,y+25);
    render.fill(0);
    render.rect(x,y+22.5,7,5);
    render.triangle(x+7,y+20,x+17,y+25,x+7,y+31); 
  },"Set 3D");
  LogicComponentRegistry.register(ReadVariable.ID,ReadVariable::new,ReadVariable::new,ReadVariable::new,(render,x,y)->{
    render.fill(150,0,0);
    render.textAlign(CENTER,CENTER);
    render.textSize(40);
    render.text("X",x+20,y+25);
    render.fill(0);
    render.rect(x+28,y+22.5,12,5);
    render.triangle(x+40,y+20,x+50,y+25,x+40,y+31); 
  },"Read Var");
  LogicComponentRegistry.register(SetVariable.ID,SetVariable::new,SetVariable::new,SetVariable::new,(render,x,y)->{
    render.fill(150,0,0);
    render.textAlign(CENTER,CENTER);
    render.textSize(40);
    render.text("X",x+25,y+25);
    render.fill(0);
    render.rect(x,y+22.5,12,5);
    render.triangle(x+12,y+20,x+22,y+25,x+12,y+31); 
  },"Set Var");
  LogicComponentRegistry.register(SetVisibility.ID,SetVisibility::new,SetVisibility::new,SetVisibility::new,(render,x,y)->{
    render.fill(0);
    render.rect(x+5,y+5,20,20);
    render.fill(255);
    render.rect(x+7,y+7,16,16);
    render.fill(0);
    render.rect(x+25,y+25,8,2);
    render.rect(x+37,y+25,8,2);
    render.rect(x+25,y+31,2,8);
    render.rect(x+43,y+31,2,8);
    render.rect(x+25,y+43,8,2);
    render.rect(x+37,y+43,8,2);
  },"Set Visability");
  LogicComponentRegistry.register(SetXOffset.ID,SetXOffset::new,SetXOffset::new,SetXOffset::new,(render,x,y)->{
    render.fill(255,0,0);
    render.triangle(x+5,y+25,x+13,y+17,x+13,y+32);
    render.rect(x+13,y+22.5,24,5);
    render.triangle(x+45,y+25,x+37,y+17,x+37,y+33);
  },"Set X Offset");
  LogicComponentRegistry.register(SetYOffset.ID,SetYOffset::new,SetYOffset::new,SetYOffset::new,(render,x,y)->{
    render.fill(0,255,0);
    render.triangle(x+25,y+5,x+17,y+13,x+33,y+13);
    render.rect(x+22.5,y+13,5,24);
    render.triangle(x+25,y+45,x+17,y+37,x+34,y+37);
  },"Set Y Offset");
  LogicComponentRegistry.register(SetZOffset.ID,SetZOffset::new,SetZOffset::new,SetZOffset::new,(render,x,y)->{
    render.fill(0,0,255);
    render.triangle(x+25.0215,y+9.0752,x+19.7469,y+12,x+30.6265,y+11.84337);
    render.quad(x+24,y+12,x+27,y+12,x+30,y+27,x+23,y+27);
    render.triangle(x+26,y+35.68181,x+17.1851,y+26.5,x+35.6415,y+26.7547);
  },"Ser Z Offset");
  
  
  
  //entitys
  EntityRegistry.register(Goon.ID,Goon::new, Goon::new,Goon::new,(render, x, y)->{
    float localX = x+25;
    float loaclY = y+38;
    float Scale = 0.73;
    //hat
    render.fill(59,59,59);
    render.rect((localX-10*Scale),(loaclY-50*Scale),20*Scale,5*Scale);
    render.rect((localX-12.5f*Scale),(loaclY-45*Scale),25*Scale,5*Scale);
    render.fill(255);
    render.rect((localX-15*Scale),(loaclY-40*Scale),30*Scale,5*Scale);
    render.fill(0);
    render.rect((localX-17.5f*Scale),(loaclY-35*Scale),35*Scale,5*Scale);
    //face
    render.fill(255,0xBA,0x6B);
    render.rect((localX-15*Scale),(loaclY-30*Scale),30*Scale,15*Scale);
    render.fill(0);
    //sun glasses
    render.rect((localX-15*Scale),(loaclY-27*Scale),30*Scale,2*Scale);
    render.rect((localX-15*Scale),(loaclY-27*Scale),10*Scale,5*Scale);
    render.rect((localX),(loaclY-27*Scale),10*Scale,5*Scale);
    //shirt
    render.fill(21,18,15);
    render.rect((localX-10*Scale),(loaclY-15*Scale),20*Scale,20*Scale);
    //legs
    render.fill(70,70,70);
    render.rect((localX-10*Scale),(loaclY+5*Scale),5*Scale,10*Scale);
    render.rect((localX+5*Scale),(loaclY+5*Scale),5*Scale,10*Scale);
  },"Goon Enemy");
  EntityRegistry.register(SimpleEntity.ID,SimpleEntity::new,SimpleEntity::new,SimpleEntity::new,(render, x, y)->{},"test entity");
  
  //other
  SerialRegistry.register(BackToMenuRequest.ID,BackToMenuRequest::new);
  SerialRegistry.register(BestScore.ID,BestScore::new);
  SerialRegistry.register(Button.ID,Button::new);
  SerialRegistry.register(ClientInfo.ID,ClientInfo::new);
  SerialRegistry.register(CloseMenuRequest.ID,CloseMenuRequest::new);
  SerialRegistry.register(CoOpStateInfo.ID,CoOpStateInfo::new);
  SerialRegistry.register(GoonMovementManager.ID,GoonMovementManager::new);
  SerialRegistry.register(Group.ID,Group::new);
  SerialRegistry.register(InfoForClient.ID,InfoForClient::new);
  SerialRegistry.register(KillEntityDataPacket.ID,KillEntityDataPacket::new);
  SerialRegistry.register(LeaderBoard.ID,LeaderBoard::new);
  SerialRegistry.register(Level.ID,Level::new);
  SerialRegistry.register(LevelDownloadInfo.ID,LevelDownloadInfo::new);
  SerialRegistry.register(LevelFileComponentData.ID,LevelFileComponentData::new);
  SerialRegistry.register(LoadLevelRequest.ID,LoadLevelRequest::new);
  SerialRegistry.register(LogicBoard.ID,LogicBoard::new);
  SerialRegistry.register(MultyPlayerEntityInfo.ID,MultyPlayerEntityInfo::new);
  SerialRegistry.register(NetworkDataPacket.ID,NetworkDataPacket::new);
  SerialRegistry.register(NoMovementManager.ID,NoMovementManager::new);
  SerialRegistry.register(Player.ID,Player::new);
  SerialRegistry.register(PlayerInfo.ID,PlayerInfo::new);
  SerialRegistry.register(PlayerMovementManager.ID,PlayerMovementManager::new);
  SerialRegistry.register(PlayerPositionInfo.ID,PlayerPositionInfo::new);
  SerialRegistry.register(RequestLevel.ID,RequestLevel::new);
  SerialRegistry.register(RequestLevelFileComponent.ID,RequestLevelFileComponent::new);
  SerialRegistry.register(SelectedLevelInfo.ID,SelectedLevelInfo::new);
  SerialRegistry.register(Stage.ID,Stage::new);
  SerialRegistry.register(StageSound.ID,StageSound::new);
}
//end of register.pde
