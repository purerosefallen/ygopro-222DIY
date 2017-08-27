--ＰＭ 雷电球
function c80000369.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c80000369.ffilter,3,2)
	c:EnableReviveLimit() 
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80000369,1))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,80000369)
	e1:SetCost(c80000369.cost)
	e1:SetTarget(c80000369.destg)
	e1:SetOperation(c80000369.desop)
	c:RegisterEffect(e1)   
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000369,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,80000361)
	e3:SetCost(c80000369.cost1)
	e3:SetCondition(c80000369.spcon)
	e3:SetTarget(c80000369.sptg)
	e3:SetOperation(c80000369.spop)
	c:RegisterEffect(e3)   
end
function c80000369.ffilter(c)
	return  c:IsSetCard(0x2d0) and c:IsRace(RACE_THUNDER)
end
function c80000369.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c80000369.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) and Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c80000369.filter(c)
	return c:IsDestructable()
end
function c80000369.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000369.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c80000369.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c80000369.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c80000369.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Damage(1-tp,1500,REASON_EFFECT)
		Duel.Damage(tp,1500,REASON_EFFECT)
	end
end
function c80000369.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and bit.band(c:GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c80000369.spfilter(c,e,tp)
	return c:IsCode(80000370) and c:IsRace(RACE_THUNDER) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:IsType(TYPE_XYZ)
end
function c80000369.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c80000369.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c80000369.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstMatchingCard(c80000369.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if tc then
		local cg=Group.FromCards(c)
		tc:SetMaterial(cg)
		Duel.Overlay(tc,cg)
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		Duel.BreakEffect()
		Duel.Damage(1-tp,1500,REASON_EFFECT)
		Duel.Damage(tp,1500,REASON_EFFECT)
		tc:CompleteProcedure()
	else
		local cg=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
		if cg:IsExists(Card.IsFacedown,1,nil) and Duel.IsPlayerCanSpecialSummon(tp) then
			Duel.ConfirmCards(1-tp,cg)
		end
	end
end