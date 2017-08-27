--秋樱之风乘载的回忆
function c1150017.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1150017.tg1)
	e1:SetOperation(c1150017.op1)
	c:RegisterEffect(e1)
	if c1150017.was==nil then
		c1150017.was=true
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1_1:SetCode(EVENT_DAMAGE)
		e1_1:SetCondition(c1150017.con1_1)
		e1_1:SetOperation(c1150017.op1_1)
		Duel.RegisterEffect(e1_1,0)
	end
--  
end
--
function c1150017.con1_1(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
--
function c1150017.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	Duel.RegisterFlagEffect(p,1150017,RESET_PHASE+PHASE_END,0,2)
end
--
function c1150017.tfilter1(c)
	return (c:GetSummonLocation()==LOCATION_GRAVE or c:GetSummonLocation()==LOCATION_REMOVED ) and c:IsAbleToDeck()
end
--
function c1150017.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=Duel.GetTurnPlayer()
	if chk==0 then return Duel.IsExistingMatchingCard(c1150017.tfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.GetFlagEffect(1-p,1150017)>0 end
	local g=Duel.GetMatchingGroup(c1150017.tfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,LOCATION_MZONE)
end
--
function c1150017.ofilter1(c,e,tp)
	return c:GetLevel()<5 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsType(TYPE_XYZ)
end
function c1150017.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1150017.tfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.BreakEffect()
	if Duel.IsExistingMatchingCard(c1150017.ofilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(1150017,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c1150017.ofilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
				local e1_1=Effect.CreateEffect(e:GetHandler())
				e1_1:SetType(EFFECT_TYPE_SINGLE)
				e1_1:SetCode(EFFECT_CANNOT_TRIGGER)
				e1_1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1_1,true)
			end
		end
	end
end







