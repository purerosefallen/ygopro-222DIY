--奇迹 神之风
function c21990006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c21990006.target)
	e1:SetOperation(c21990006.activate)
	c:RegisterEffect(e1)
end
function c21990006.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c21990006.cffilter(c)
	return c:IsType(TYPE_QUICKPLAY) and not c:IsPublic()
end
function c21990006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c21990006.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21990006.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) 
		and Duel.IsExistingMatchingCard(c21990006.cffilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	local rt=Duel.GetTargetCount(c21990006.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,c21990006.cffilter,tp,LOCATION_HAND,0,1,rt,e:GetHandler())
	Duel.ConfirmCards(1-tp,cg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c21990006.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,cg:GetCount(),cg:GetCount(),e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.ShuffleHand(tp)
end
function c21990006.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if rg:GetCount()>0 then 
		Duel.Destroy(rg,REASON_EFFECT)
	end
end