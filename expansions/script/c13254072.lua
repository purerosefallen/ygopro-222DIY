--飞球之仁慈
function c13254072.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13254072,0))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,13254072+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c13254072.condition)
	e1:SetTarget(c13254072.target)
	e1:SetOperation(c13254072.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13254072,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,13254072+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c13254072.condition1)
	e2:SetTarget(c13254072.target1)
	e2:SetOperation(c13254072.activate1)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13254072,2))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,13254072+EFFECT_COUNT_CODE_OATH)
	e3:SetCondition(c13254072.condition2)
	e3:SetTarget(c13254072.target2)
	e3:SetOperation(c13254072.activate2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e5:SetTarget(c13254072.target2f)
	c:RegisterEffect(e5)
	--Activate
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(13254072,3))
	e6:SetCategory(CATEGORY_HANDES)
	e6:SetType(EFFECT_TYPE_ACTIVATE)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCountLimit(1,13254072+EFFECT_COUNT_CODE_OATH)
	e6:SetCondition(c13254072.condition3)
	e6:SetTarget(c13254072.target3)
	e6:SetOperation(c13254072.activate3)
	c:RegisterEffect(e6)
	
end
function c13254072.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3356)
end
function c13254072.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return Duel.GetMatchingGroup(c13254072.cfilter,tp,LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)>=2 and at:GetControler()~=tp
end
function c13254072.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c13254072.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
	Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_DISCARD+REASON_EFFECT)
end
function c13254072.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroup(c13254072.cfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)>=4 and ep~=tp and Duel.IsChainNegatable(ev)
end
function c13254072.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c13254072.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local g=Duel.GetFieldGroup(ep,LOCATION_HAND,0,nil)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
end
function c13254072.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroup(c13254072.cfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)>=6
end
function c13254072.filter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()~=tp and c:IsCanTurnSet()
end
function c13254072.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c13254072.filter,1,nil,tp) and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	local g=eg:Filter(c13254072.filter,nil,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c13254072.target2f(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return rp==1-tp and tc:IsFaceup() and tc:IsCanTurnSet() and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c13254072.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g1:GetCount()>0 then
		Duel.ConfirmCards(tp,g1)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DISCARD)
		local sg=g1:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
end
function c13254072.condition3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroup(c13254072.cfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)==7
end
function c13254072.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>1 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,2)
end
function c13254072.activate3(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	if g:GetCount()>1 then
		Duel.DiscardHand(1-tp,aux.TRUE,2,2,REASON_DISCARD+REASON_EFFECT)
	end
end
