--王圣之结界像
function c11113129.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c11113129.fscon)
	e1:SetOperation(c11113129.fsop)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.fuslimit)
	c:RegisterEffect(e2)
	--attribute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_ADD_ATTRIBUTE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(0x2f)
	c:RegisterEffect(e3)
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetValue(c11113129.aclimit)
	c:RegisterEffect(e4)
	--disable spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	e5:SetTarget(c11113129.sumlimit)
	c:RegisterEffect(e5)
end
function c11113129.aclimit(e,re,tp)
	local att=e:GetHandler():GetAttribute()
	return re:IsActiveType(TYPE_MONSTER) and bit.band(att,re:GetHandler():GetOriginalAttribute())~=0 and not re:GetHandler():IsImmuneToEffect(e)
end
function c11113129.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	local att=e:GetHandler():GetAttribute()
	return bit.band(att,c:GetOriginalAttribute())~=0
end
function c11113129.fsfilter(c,fc)
	return c:GetLevel()==4 and c:GetAttack()==1000 and c:GetDefense()==1000 and c:IsCanBeFusionMaterial(fc) and c:GetAttribute()>0
end
function c11113129.CheckRecursive(c,mg,sg,fc,chkf)
	if sg:IsContains(c) then return false end
	local sg1=sg:Clone()
	sg1:AddCard(c)
	if sg1:GetCount()==6 then
		if fc:GetFlagEffect(11113130)>0 and sg1:IsExists(Card.IsLocation,5,nil,LOCATION_DECK) then return false end
		if chkf~=PLAYER_NONE and not sg1:IsExists(aux.FConditionCheckF,1,nil,chkf) then return false end
		local att=0
		for tc in aux.Next(sg1) do
			att=bit.bor(tc:GetAttribute(),att)
		end
		local ct=0
		for i=0,6 do
			if bit.band(bit.lshift(1,i),att)~=0 then ct=ct+1 end
		end
		return ct>=6
	end
	return mg:IsExists(c11113129.CheckRecursive,1,nil,mg,sg1,fc,chkf)
end
function c11113129.fscon(e,g,gc,chkf)
	if g==nil then return true end
	local sg=Group.CreateGroup()
	if gc then sg:AddCard(gc) end
	local fs=false
	local mg=g:Filter(c11113129.fsfilter,nil,e:GetHandler())
	return mg:IsExists(c11113129.CheckRecursive,1,nil,mg,sg,e:GetHandler(),chkf)
end
function c11113129.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local sg=Group.CreateGroup()
	local c=e:GetHandler()
	if gc then sg:AddCard(gc) end
	local mg=eg:Filter(c11113129.fsfilter,nil,e:GetHandler())
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g=mg:FilterSelect(tp,c11113129.CheckRecursive,1,1,nil,mg,sg,e:GetHandler(),chkf)
		sg:Merge(g)
	until sg:GetCount()==6
	Duel.SetFusionMaterial(sg)
end