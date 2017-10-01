--残留的愿望·Coconatsu
local m=37564324
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(cm.FConditionCode2)
	e1:SetOperation(cm.FOperationCode2)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.drtg)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and cm.material
	end)
	e0:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local code1=cm.material[1]
		local code2=cm.material[2]
		local f=Card.RegisterEffect
		Card.RegisterEffect=function(c,e,forced)
			if e:IsHasType(0x7e0) then
				e:SetCondition(aux.TRUE)
			end
			f(c,e,forced)
		end
		e:GetHandler():CopyEffect(code1,RESET_EVENT+0x1fe0000,1)
		e:GetHandler():CopyEffect(code2,RESET_EVENT+0x1fe0000,1)
		Card.RegisterEffect=f
	end)
	c:RegisterEffect(e0)
end
function cm.ctfilter(c,code)
	return c:GetOriginalCode()==code
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsFacedown() end
	Duel.ConfirmCards(1-tp,e:GetHandler())
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_EXTRA,2,nil)
	end
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_EXTRA,nil)
	if g:GetCount()<2 then return end
	local sg=g:RandomSelect(tp,2)
	Duel.ConfirmCards(tp,sg)
	local s1=sg:GetFirst():GetOriginalCode()
	local s2=sg:GetNext():GetOriginalCode()
	cm.material={s1,s2}
	cm.material_count=2
	local ex=Effect.CreateEffect(e:GetHandler())
	ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ex:SetCode(EVENT_PHASE+PHASE_END)
	ex:SetOperation(function(e)
		cm.material=nil
		cm.material_count=nil
		e:Reset()
	end)
	Duel.RegisterEffect(ex,tp)
end
function cm.GenerateList(t)
	local res={}
	for i,code in pairs(t) do
		local f=function(c,fc,sub) return c:IsFusionCode(code) or (sub and c:CheckFusionSubstitute(fc)) end
		table.insert(res,f)
	end
	return res
end
function cm.FConditionCode2(e,g,gc,chkfnf)
				if g==nil then return true end
				if not cm.material then return false end
				local funs=cm.GenerateList(cm.material)
				local chkf=bit.band(chkfnf,0xff)
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=bit.rshift(chkfnf,8)~=0
				local sub=sub or notfusion
				local mg=g:Filter(Auxiliary.FConditionFilterMix,c,c,sub,table.unpack(funs))
				if gc then
					if not mg:IsContains(gc) then return false end
					local sg=Group.CreateGroup()
					return Auxiliary.FSelectMix(gc,tp,mg,sg,c,sub,table.unpack(funs))
				end
				local sg=Group.CreateGroup()
				return mg:IsExists(Auxiliary.FSelectMix,1,nil,tp,mg,sg,c,sub,table.unpack(funs))
end
function cm.FOperationCode2(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
				local funs=cm.GenerateList(cm.material)
				local chkf=bit.band(chkfnf,0xff)
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=bit.rshift(chkfnf,8)~=0
				local sub=sub or notfusion
				local mg=eg:Filter(Auxiliary.FConditionFilterMix,c,c,sub,table.unpack(funs))
				local sg=Group.CreateGroup()
				if gc then sg:AddCard(gc) end
				while sg:GetCount()<#funs do
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					local g=mg:FilterSelect(tp,Auxiliary.FSelectMix,1,1,sg,tp,mg,sg,c,sub,table.unpack(funs))
					sg:Merge(g)
				end
				Duel.SetFusionMaterial(sg)
end