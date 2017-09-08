--流转于湛蓝的幻想
function c1111008.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c1111008.cost1)
	e1:SetCondition(c1111008.con1)
	e1:SetTarget(c1111008.tg1)
	e1:SetOperation(c1111008.op1)
	c:RegisterEffect(e1)	
--
end
--
function c1111008.IsLd(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ld
end
--
function c1111008.cfilter1(c)
	return c:GetSummonType()==SUMMON_TYPE_FUSION and c:IsFaceup()
end
function c1111008.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.CheckLPCost(tp,800) and Duel.GetMatchingGroupCount(c1111008.cfilter1,tp,0,LOCATION_MZONE,nil)>1 and Duel.SelectYesNo(tp,aux.Stringid(1111008,0)) then
		Duel.PayLPCost(tp,800)
		e:SetLabel(1)
	end
end
--
function c1111008.cfilter1(c)
	return c:IsFaceup() and c:GetLevel()<4 and c:GetSummonType()==SUMMON_TYPE_NORMAL 
end
function c1111008.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1111008.cfilter1,tp,LOCATION_ONFIELD,0,1,nil) and Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_MZONE,0,nil)==1
end
--
function c1111008.tfilter0(c)
	return c:GetSummonType()==SUMMON_TYPE_SPECIAL and c:IsFaceup()
end
function c1111008.tfilter1(c)
	return c1111008.IsLd(c) and c:IsAbleToHand()
end
function c1111008.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1111008.tfilter1,tp,LOCATION_DECK,0,1,nil) end
	local sg=Duel.GetMatchingGroup(c1111008.tfilter0,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
	if sg:GetCount()>1 then
	   Duel.SetChainLimit(c1111008.limit1)
	end
end
function c1111008.limit1(e,ep,tp)
	return tp==ep
end
--
function c1111008.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1111008.tfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end