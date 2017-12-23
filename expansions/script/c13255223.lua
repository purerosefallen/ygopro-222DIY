--异界锁链使 安迪
function c13255223.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13255223,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetTarget(c13255223.postg)
	e1:SetOperation(c13255223.posop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13255223,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_CONFIRM)
	e2:SetCountLimit(1,13255223)
	e2:SetTarget(c13255223.destg)
	e2:SetOperation(c13255223.desop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13255223,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,13255223)
	e3:SetTarget(c13255223.sptg)
	e3:SetOperation(c13255223.spop)
	c:RegisterEffect(e3)
	
end
function c13255223.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,sg,sg:GetCount(),0,0)
end
function c13255223.posop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if sg:GetCount()>0 then
		Duel.ChangePosition(sg,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
	end
end
function c13255223.thfilter(c)
	return c:IsLevelBelow(1) and c:IsAbleToHand()
end
function c13255223.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local t=Duel.GetAttackTarget()
	if chk ==0 then return Duel.GetAttacker()==e:GetHandler() and t~=nil and not t:IsAttackPos() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,t,1,0,0)
end
function c13255223.desop(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetAttackTarget()
	if t~=nil and t:IsRelateToBattle() and not t:IsAttackPos() then
		if Duel.Destroy(t,REASON_EFFECT)~=0 and Duel.GetMatchingGroupCount(c13255223.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(13255223,2)) then
			local sg=Duel.SelectMatchingCard(tp,c13255223.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
			if sg:GetCount()>0 then
				Duel.SendtoHand(sg,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		end
	end
end
function c13255223.spfilter(c,e,tp)
	return c:IsLevelBelow(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13255223.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=eg:Filter(c13255223.spfilter,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=sg:GetCount()
		and sg:GetCount()>0 end
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c13255223.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c13255223.spfilter,nil,e,tp)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<sg:GetCount() then return end
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end

