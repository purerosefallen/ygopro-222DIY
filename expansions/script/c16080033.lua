--新津 雪乃
function c16080033.initial_effect(c)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(aux.FALSE)
	c:RegisterEffect(e4)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,16080033)
	e1:SetTarget(c16080033.target)
	e1:SetOperation(c16080033.operation)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c16080033.target1)
	e2:SetOperation(c16080033.operation1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c16080033.cfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5ca) and c:IsLevelAbove(6)
end
function c16080033.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) and 
	Duel.IsExistingMatchingCard(c16080033.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c16080033.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.ChangePosition(g1,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c16080033.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
		c:CompleteProcedure()
	end
end
function c16080033.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c16080033.operation1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end