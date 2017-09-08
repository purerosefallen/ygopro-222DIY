--七曜-日符『皇家圣焰』
function c2170707.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,2170707+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c2170707.target)
	e1:SetOperation(c2170707.activate)
	c:RegisterEffect(e1)
end
function c2170707.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c2170707.cffilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x211) and not c:IsPublic()
end
function c2170707.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c2170707.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c2170707.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) 
		and Duel.IsExistingMatchingCard(c2170707.cffilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	local rt=Duel.GetTargetCount(c2170707.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,c2170707.cffilter,tp,LOCATION_HAND,0,1,99,e:GetHandler())
	Duel.ConfirmCards(1-tp,cg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c2170707.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0,cg:GetCount(),nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.ShuffleHand(tp)
end
function c2170707.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if rg:GetCount()>0 then 
		Duel.Destroy(rg,REASON_EFFECT)
	end
end