--水难事故的念缚灵
function c1156012.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c1156012.lkcheck,2,2)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c1156012.con1)
	e1:SetTarget(c1156012.tg1)
	e1:SetOperation(c1156012.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetCondition(c1156012.con2)
	e2:SetValue(c1156012.limit2)
	c:RegisterEffect(e2)
--
end
--
function c1156012.lkcheck(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WATER) and c:GetSummonLocation()==LOCATION_GRAVE 
end
--
function c1156012.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
--
function c1156012.tfilter1(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_MONSTER) and not (c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_ZOMBIE))
end
function c1156012.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(c1156012.tfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
--
function c1156012.ofilter1(c,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:GetOwner()==1-tp
end
function c1156012.op1(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c1156012.tfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if Duel.SendtoGrave(sg,REASON_EFFECT)~=0 then
		local mg=sg:Filter(c1156012.ofilter1,nil,tp)
		if mg:GetCount()>0 then
			local num=mg:GetCount()
			Duel.Damage(1-tp,num*500,REASON_EFFECT)
		end
	end
end
--
function c1156012.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()>=5 and c:IsFaceup()
end
--
function c1156012.limit2(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not (re:GetHandler():IsAttribute(ATTRIBUTE_WATER) and re:GetHandler():IsImmuneToEffect(e))
end
--




