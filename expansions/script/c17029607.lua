--Psychether Maiden, Jezebel
function c17029607.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17029607,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,17029607+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c17029607.tdtg)
	e1:SetOperation(c17029607.tdop)
	c:RegisterEffect(e1)
	--Activate, SS self
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17029607,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,17029607+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c17029607.spcost)
	e2:SetTarget(c17029607.sptg)
	e2:SetOperation(c17029607.spop)
	c:RegisterEffect(e2)
	--reveal
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17029607,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c17029607.revcon)
	e3:SetTarget(c17029607.revtg)
	e3:SetOperation(c17029607.revop)
	c:RegisterEffect(e3)
end
function c17029607.tdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x720) and not c:IsCode(17029607) and c:IsAbleToHand()
end
function c17029607.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c17029607.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c17029607.tdfilter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c17029607.tdfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function c17029607.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoDeck(sg,2,nil,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	end
end
function c17029607.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x720) and c:IsAbleToRemoveAsCost()
end
function c17029607.cfcost(c)
	return c:IsCode(17029609) and c:IsAbleToRemoveAsCost()
end
function c17029607.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c17029607.cfilter,tp,LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c17029607.cfcost,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(17029609,1))) then
		local tg=Duel.GetFirstMatchingCard(c17029607.cfcost,tp,LOCATION_GRAVE,0,nil)
		Duel.Remove(tg,POS_FACEUP,REASON_COST)
	else
		local g=Duel.SelectMatchingCard(tp,c17029607.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c17029607.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,17029607,0x720,0x21,1500,1500,4,RACE_FAIRY,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c17029607.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,17029607,0x720,0x21,1500,1500,4,RACE_FAIRY,ATTRIBUTE_LIGHT) then
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
		e2:SetValue(c17029607.valct)
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
		--draw
		local e5=Effect.CreateEffect(c)
		e5:SetDescription(aux.Stringid(17029607,3))
		e5:SetCategory(CATEGORY_DRAW)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e5:SetCode(EVENT_TO_HAND)
		e5:SetProperty(EFFECT_FLAG_DELAY)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCountLimit(1)
		e5:SetCondition(c17029607.drcon)
		e5:SetTarget(c17029607.drtg)
		e5:SetOperation(c17029607.drop)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e5)
		Duel.SpecialSummonComplete()
	end
end
function c17029607.valct(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c17029607.drfilter(c,tp)
	return c:IsSetCard(0x720) and c:IsType(TYPE_SPELL)
end
function c17029607.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c17029607.drfilter,1,nil,tp)
end
function c17029607.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c17029607.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c17029607.cfilter2(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x720) and not c:IsCode(17029607)
end
function c17029607.revcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c17029607.cfilter2,tp,LOCATION_GRAVE,0,1,e:GetHandler())
end
function c17029607.revfilter(c)
	return not c:IsPublic()
end
function c17029607.revtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17029607.revfilter,tp,0,LOCATION_HAND,1,nil) end
end
function c17029607.revop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectMatchingCard(tp,c17029607.revfilter,tp,0,LOCATION_HAND,1,1,nil)
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
