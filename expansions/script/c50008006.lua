--妖精传说-糖果屋
local m=50008006
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,cm.sfilter,aux.NonTuner(cm.sfilter),1)
	c:EnableReviveLimit()
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CLIENT_HIN)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.drcon)
	e3:SetCost(cm.drcost)
	e3:SetTarget(cm.drtg)
	e3:SetOperation(cm.drop)
	c:RegisterEffect(e3)
	--To grave
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.rmcon)
	e4:SetTarget(cm.rmtg)
	e4:SetOperation(cm.rmop)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,4))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLED)
	e5:SetCondition(cm.rmcon1)
	e5:SetTarget(cm.rmtg1)
	e5:SetOperation(cm.rmop1)
	c:RegisterEffect(e5)
end
function cm.sfilter(c)
	return  c:IsRace(RACE_SPELLCASTER)
end
function cm.filter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsControler(tp) and c:GetAttack()==1850
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(cm.filter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,e,tp)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>=4
end
function cm.rmcon1(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(cm.filter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,e,tp)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>=6
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(cm.filter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,e,tp)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>=2
end
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_DISCARD+REASON_COST)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
--
function cm.rmfilter(c,ft)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToGrave()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.rmfilter(chkc,ft) end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.rmfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_HAND+LOCATION_ONFIELD)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
			local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
			local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
			local sg=Group.CreateGroup()
			if g1:GetCount()>0 and (g2:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(m,2))) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local sg1=g1:Select(tp,1,1,nil)
				Duel.HintSelection(sg1)
				sg:Merge(sg1)
			end
			if g2:GetCount()>0 and (g1:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(m,3))) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local sg1=g2:Select(tp,1,1,nil)
				Duel.HintSelection(sg1)
				sg:Merge(sg1)
			end
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
--
function cm.rmtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function cm.rmop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end