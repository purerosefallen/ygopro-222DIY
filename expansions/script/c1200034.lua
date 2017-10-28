--靜儀式 記憶之海
function c1200034.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1200034,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c1200034.condition)
	e1:SetTarget(c1200034.target)
	e1:SetOperation(c1200034.activate)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1200034,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,1200034)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c1200034.con)
	e1:SetTarget(c1200034.sptg)
	e1:SetOperation(c1200034.spop)
	c:RegisterEffect(e1)
end
function c1200034.filter(c,p)
	return c:GetControler()==p and c:IsOnField() and (c:IsSetCard(0xfba) or c:IsSetCard(0xfbc)) and c:IsFaceup()
end
function c1200034.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(c1200034.filter,nil,tp)-tg:GetCount()>1
end
function c1200034.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c1200034.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if not tc:IsDisabled() then
		if Duel.NegateEffect(ev) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end
end
function c1200034.cfilter(c,tp)
	return  c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp and c:IsPreviousPosition(POS_FACEUP)
		and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp)) and (c:IsSetCard(0xfba) and c:IsType(TYPE_MONSTER))
end
function c1200034.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1200034.cfilter,1,nil,tp)
end
function c1200034.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false,POS_FACEUP) and c:IsSetCard(0xfba)
end
function c1200034.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1200034.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCountFromEx(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
end
function c1200034.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return false end
	if Duel.GetLocationCountFromEx(tp)<1 then return false end
	if not Duel.IsExistingMatchingCard(c1200034.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then return false end
	local sg=Duel.SelectMatchingCard(tp,c1200034.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=sg:GetFirst()
	if sc then 
		if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,true,false,POS_FACEUP)>0 then
			Duel.Overlay(sc,Group.FromCards(c))
		end
	end
end