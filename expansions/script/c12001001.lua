--六曜 大安的卡莲特尔
function c12001001.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12001001,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,12001001)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c12001001.target)
	e1:SetOperation(c12001001.operation)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12001001,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,12001101)
	e3:SetCondition(c12001001.dscon)
	e3:SetTarget(c12001001.dstg)
	e3:SetOperation(c12001001.dsop)
	c:RegisterEffect(e3)
 end
function c12001001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c12001001.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsSetCard(0xfb0) then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
end
end
function c12001001.dscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsReason(REASON_REVEAL)
end
function c12001001.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK)
end
function c12001001.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12001001.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c12001001.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tg=g:GetMaxGroup(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c12001001.dsop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c12001001.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetAttack)
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			local tc=sg:GetFirst()
			local atk=tc:IsFaceup() and tc:GetAttack() or 0
		  if Duel.Destroy(sg,REASON_EFFECT)==1 and atk~=0
				then Duel.Recover(tp,atk,REASON_EFFECT)
					 Duel.Recover(1-tp,atk,REASON_EFFECT)
			   end
		  else
			local tc=tg:GetFirst()
			local atk=tc:IsFaceup() and tc:GetAttack() or 0
			if Duel.Destroy(tg,REASON_EFFECT)==1 and atk~=0 
				then Duel.Recover(tp,atk,REASON_EFFECT)
					 Duel.Recover(1-tp,atk,REASON_EFFECT)
			end
		end
	end
end
