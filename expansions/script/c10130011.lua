--幻层驱动 超Χ构筑
function c10130011.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xa336),aux.NonTuner(nil),1)
	c:EnableReviveLimit()   
	--Search or SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10130011,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10130011)
	e1:SetCost(c10130011.rmcost)
	e1:SetTarget(c10130011.rmtg)
	e1:SetOperation(c10130011.rmop)
	c:RegisterEffect(e1)	
	--flip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10130011,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,10130111)
	e2:SetTarget(c10130011.drtg)
	e2:SetOperation(c10130011.drop)
	c:RegisterEffect(e2) 
end
function c10130011.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c10130011.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.Draw(p,2,REASON_EFFECT)==2 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
function c10130011.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN_DEFENSE)
end
function c10130011.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil) end
end
function c10130011.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()<=0 then return end
	Duel.ShuffleSetCard(g)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_FACEDOWN)
	local tg=g:Select(1-tp,1,1,nil)
		  Duel.ConfirmCards(1-tp,tg)
		  Duel.BreakEffect()
		  local rg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
		  if not tg:GetFirst():IsCode(10130011) and rg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10130011,2)) then
			  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)   
			  local rg2=rg:Select(tp,1,1,nil)
			  Duel.Remove(rg,POS_FACEUP,REASON_RULE)
		  end   
end