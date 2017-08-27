--★魔晶石(マナプリズム)を生み出すもの キメラ
function c114000989.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,114000989)
	e2:SetCondition(c114000989.spcon)
	e2:SetOperation(c114000989.spop)
	c:RegisterEffect(e2)
	--sp summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DESTROYED)
	--e3:SetCondition(c114000989.setcon)
	e3:SetTarget(c114000989.settg)
	e3:SetOperation(c114000989.setop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c114000989.spconfilter(c,att)
	return c:IsAttribute(att) and ( c:IsSetCard(0xcabb) or c:IsSetCard(0x1223) )
end
function c114000989.spcon(e,c)
	if c==nil then return true end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<0 then return false end
	local gwt=Duel.GetMatchingGroup(c114000989.spconfilter,c:GetControler(),LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil,ATTRIBUTE_WATER)
	local gwd=Duel.GetMatchingGroup(c114000989.spconfilter,c:GetControler(),LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil,ATTRIBUTE_WIND)
	local ger=Duel.GetMatchingGroup(c114000989.spconfilter,c:GetControler(),LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil,ATTRIBUTE_EARTH)
	local gfr=Duel.GetMatchingGroup(c114000989.spconfilter,c:GetControler(),LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil,ATTRIBUTE_FIRE)
	local gcost=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)
	return gwt:GetCount()>0 and gwd:GetCount()>0 and ger:GetCount()>0 and gfr:GetCount()>0 and gcost:GetCount()>0
end
function c114000989.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g,tc
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 then
		g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		tc=g:Select(tp,1,1,nil)
	else
		g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_MZONE,0,nil)
		tc=g:Select(tp,1,1,nil)
	end
	local tg=tc:GetFirst()
	Duel.Remove(tg,POS_FACEUP,REASON_COST)
	e:SetLabelObject(tg)
	tg:RegisterFlagEffect(114000989,RESET_EVENT+0x1fe0000,0,1)
end

--function c114000989.setcon(e,tp,eg,ep,ev,re,r,rp)
--	local tc=e:GetLabelObject():GetLabelObject()
--	return tc and tc:GetFlagEffect(114000989)~=0
--end
function c114000989.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=e:GetLabelObject():GetLabelObject()
	if tc then
		if tc:IsType(TYPE_MONSTER) and tc:GetFlagEffect(114000989)~=0 then
			Duel.SetTargetCard(tc)
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
		else
			e:SetCategory(0)
		end
	else
		e:SetCategory(0)
	end
end
function c114000989.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc then return end
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsType(TYPE_MONSTER) then
		local ow=tc:GetControler()
		Duel.SpecialSummon(tc,0,tp,ow,false,false,POS_FACEUP)
	end
end
