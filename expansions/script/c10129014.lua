--地狱鬼神 美洛厄尼斯
function c10129014.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c10129014.splimit)
	c:RegisterEffect(e0)
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c10129014.fscondition)
	e1:SetOperation(c10129014.fsoperation)
	c:RegisterEffect(e1)	
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c10129014.matcheck)
	c:RegisterEffect(e2)
end
function c10129014.matcheck(e,c)
	local ct=c:GetMaterial():GetCount()
	if ct>=2 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetDescription(aux.Stringid(10129014,0))
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0xfe0000)
		c:RegisterEffect(e1,true)
	end
	if ct>=3 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetDescription(aux.Stringid(10129014,1))
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetReset(RESET_EVENT+0xfe0000)
		e2:SetValue(c10129014.efilter1)
		c:RegisterEffect(e2,true)
	end
	if ct>=4 then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetDescription(aux.Stringid(10129014,2))
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e3:SetRange(LOCATION_MZONE)
		e3:SetReset(RESET_EVENT+0xfe0000)
		e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e3:SetValue(aux.tgoval)
		c:RegisterEffect(e3,true)
	end
	if ct>=5 then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetDescription(aux.Stringid(10129014,3))
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetReset(RESET_EVENT+0xfe0000)
		e4:SetValue(c10129014.efilter2)
		c:RegisterEffect(e4,true)
	end
end
function c10129014.efilter2(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetHandlerPlayer()~=e:GetHandlerPlayer() and te:GetHandler():GetSummonLocation()==LOCATION_EXTRA 
end
function c10129014.efilter1(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c10129014.fscondition(e,g,gc)
	if g==nil then return true end
	if gc then return false end
	return g:IsExists(Card.IsRace,2,nil,RACE_ZOMBIE)
end
function c10129014.fsoperation(e,tp,eg,ep,ev,re,r,rp,gc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	Duel.SetFusionMaterial(eg:FilterSelect(tp,Card.IsRace,2,eg:GetCount(),nil,RACE_ZOMBIE))
end
function c10129014.splimit(e,se,sp,st)
	return st==SUMMON_TYPE_FUSION+101
end