--新津 莲
function c16080034.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetCondition(c16080034.excon)
	e1:SetTarget(c16080034.extg)
	c:RegisterEffect(e1)
	--SynchroSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16080034,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetCountLimit(1,16080034)
	e2:SetCondition(c16080034.con)
	e2:SetTarget(c16080034.sctg)
	e2:SetOperation(c16080034.scop)
	c:RegisterEffect(e2)
end
function c16080034.excon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPosition()==POS_FACEUP_ATTACK 
end
function c16080034.extg(e,c)
	return c:IsSetCard(0x5ca)
end
function c16080034.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_CONTINUOUS_POS) and c:IsPosition(POS_FACEUP_DEFENSE) and c:IsPreviousPosition(POS_FACEUP_ATTACK)
end
function c16080034.mfilter(c)
	return c:IsSetCard(0x5ca)
end
function c16080034.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c16080034.mfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c16080034.scop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c16080034.mfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
	end
end