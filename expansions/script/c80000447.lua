--ＬＰＭ 骑拉帝纳·另类型态
function c80000447.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c80000447.ffilter,8,5)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c80000447.efilter)
	c:RegisterEffect(e1) 
	--cannot activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c80000447.aclimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SSET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c80000447.aclimset)
	c:RegisterEffect(e3)
	--spsummon limit
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(c80000447.splimit)
	c:RegisterEffect(e4) 
	--Activate(summon)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_QUICK_F)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetCost(c80000447.discost)
	e5:SetTarget(c80000447.target)
	e5:SetOperation(c80000447.activate)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_QUICK_F)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e6:SetCost(c80000447.discost)
	e6:SetTarget(c80000447.target)
	e6:SetOperation(c80000447.activate)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_TODECK)
	e7:SetType(EFFECT_TYPE_QUICK_F)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetCost(c80000447.discost)
	e7:SetTarget(c80000447.target2)
	e7:SetOperation(c80000447.activate2)
	c:RegisterEffect(e7)
	--spsummon
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(80000447,0))
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(c80000447.condition1)
	e8:SetTarget(c80000447.sptg)
	e8:SetOperation(c80000447.spop)
	c:RegisterEffect(e8)
end
function c80000447.ffilter(c)
	return  c:IsSetCard(0x2d0) and c:IsAttackable(ATTRIBUTE_DARK)
end
function c80000447.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and not (se:GetHandler():IsType(TYPE_SPELL) or se:GetHandler():IsType(TYPE_MONSTER) or se:GetHandler():IsType(TYPE_TRAP))
end
function c80000447.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80000447.aclimit(e,re,tp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:IsActiveType(TYPE_SPELL) then return false end
	local c=re:GetHandler()
	return not c:IsLocation(LOCATION_SZONE) or c:GetFlagEffect(80000447)>0
end
function c80000447.aclimset(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(80000447,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1)
		tc=eg:GetNext()
	end
end
function c80000447.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80000447.filter(c,tp,ep)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_DARK)
		and ep~=tp and c:IsAbleToDeck()
end
function c80000447.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return c80000447.filter(tc,tp,ep) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c80000447.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsAttribute(ATTRIBUTE_DARK) then
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	end
end
function c80000447.filter2(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_DARK) and c:GetSummonPlayer()~=tp
		and c:IsAbleToRemove()
end
function c80000447.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c80000447.filter2,1,nil,tp) end
	local g=eg:Filter(c80000447.filter2,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c80000447.filter3(c,e,tp)
	return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_DARK) and c:GetSummonPlayer()~=tp
		and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE)
end
function c80000447.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c80000447.filter3,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	end
end


function c80000447.cfilter(c)
	return c:IsFaceup() and c:IsCode(80000449)
end
function c80000447.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c80000447.filter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(80000449)
end
function c80000447.filter(c,e,tp,rk)
	return c:IsCode(80000448) and e:GetHandler():IsCanBeXyzMaterial(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,true)
end
function c80000447.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c80000447.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler():GetRank()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c80000447.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80000447.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c:GetRank())
	local sc=g:GetFirst()
	if sc then
		local mg=c:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(sc,Group.FromCards(c))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,true,true,POS_FACEUP)
		sc:CompleteProcedure()
	end
end