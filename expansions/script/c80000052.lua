--口袋妖怪 迷你龙
function c80000052.initial_effect(c) 
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000052,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,80000052)
	e2:SetTarget(c80000052.sptg)
	e2:SetOperation(c80000052.spop)
	c:RegisterEffect(e2)
   --xyz limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e4:SetValue(c80000052.xyzlimit)
	c:RegisterEffect(e4)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80000052,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,80000053)
	e1:SetTarget(c80000052.target)
	e1:SetOperation(c80000052.operation)
	c:RegisterEffect(e1)
end
function c80000052.xyzlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x2d0)
end
function c80000052.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,1)
end
function c80000052.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	Duel.Draw(tp,1,REASON_EFFECT)
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if tc:IsSetCard(0x2d0) then
			Duel.Recover(tp,1000,REASON_EFFECT)
		else
			Duel.Damage(tp,1000,REASON_EFFECT)
		end
		Duel.ShuffleHand(tp)
	end
end
function c80000052.filter(c)
	return c:IsSetCard(0x2d0) and c:IsSummonable(true,nil)
end
function c80000052.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c80000052.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c80000052.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c80000052.filter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end