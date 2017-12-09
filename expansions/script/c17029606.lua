--Psychether Librarian, Kuval
function c17029606.initial_effect(c)
	--Excavate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17029606,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,17029606+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c17029606.exctg)
	e1:SetOperation(c17029606.excop)
	c:RegisterEffect(e1)
	--Activate, SS self
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17029606,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,17029606+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c17029606.spcost)
	e2:SetTarget(c17029606.sptg)
	e2:SetOperation(c17029606.spop)
	c:RegisterEffect(e2)
	--reveal
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17029606,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c17029606.revcon)
	e3:SetTarget(c17029606.revtg)
	e3:SetOperation(c17029606.revop)
	c:RegisterEffect(e3)
end
function c17029606.exctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return false end
		local g=Duel.GetDecktopGroup(tp,5)
		return g:FilterCount(Card.IsAbleToHand,nil)>0
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c17029606.excfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x720) and c:IsType(TYPE_SPELL)
end
function c17029606.excop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,5)
	local g=Duel.GetDecktopGroup(p,5)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		if g:IsExists(c17029606.excfilter,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c17029606.excfilter,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-p,sg)
			Duel.ShuffleHand(p)
		end
		Duel.ShuffleDeck(p)
	end
end
function c17029606.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x720) and c:IsAbleToRemoveAsCost()
end
function c17029606.cfcost(c)
	return c:IsCode(17029609) and c:IsAbleToRemoveAsCost()
end
function c17029606.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c17029606.cfilter,tp,LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c17029606.cfcost,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(17029609,1))) then
		local tg=Duel.GetFirstMatchingCard(c17029606.cfcost,tp,LOCATION_GRAVE,0,nil)
		Duel.Remove(tg,POS_FACEUP,REASON_COST)
	else
		local g=Duel.SelectMatchingCard(tp,c17029606.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c17029606.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,17029606,0x720,0x21,1500,1500,4,RACE_FAIRY,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c17029606.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,17029606,0x720,0x21,1500,1500,4,RACE_FAIRY,ATTRIBUTE_LIGHT) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP_ATTACK)
		c:AddMonsterAttributeComplete()
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(17029602,4))
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e2:SetCountLimit(1)
		e2:SetValue(c17029606.valct)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetReset(RESET_EVENT+0x47e0000)
		e4:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e4,true)
		local e5=Effect.CreateEffect(c)
		e5:SetDescription(aux.Stringid(17029606,3))
		e5:SetCategory(CATEGORY_TOHAND)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e5:SetCode(EVENT_PREDRAW)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCondition(c17029606.thcon)
		e5:SetTarget(c17029606.thtg)
		e5:SetOperation(c17029606.thop)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e5,true)
		Duel.SpecialSummonComplete()
	end
end
function c17029606.valct(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c17029606.thcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
end
function c17029606.thfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x720) and not c:IsCode(17029606) and c:IsAbleToHand() and c:IsFaceup()
end
function c17029606.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c17029606.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c17029606.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		e:SetLabel(1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectTarget(tp,c17029606.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	else e:SetLabel(0) end
end
function c17029606.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetLabel()==1 and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c17029606.cfilter2(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x720) and not c:IsCode(17029606)
end
function c17029606.revcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c17029606.cfilter2,tp,LOCATION_GRAVE,0,1,e:GetHandler())
end
function c17029606.revfilter(c)
	return not c:IsPublic()
end
function c17029606.revtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17029606.revfilter,tp,0,LOCATION_HAND,1,nil) end
end
function c17029606.revop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectMatchingCard(tp,c17029606.revfilter,tp,0,LOCATION_HAND,1,1,nil)
    Duel.HintSelection(g)
    local tc=g:GetFirst()
    if tc then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_PUBLIC)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
end
