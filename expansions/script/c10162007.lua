--太古龙·虚梦龙
function c10162007.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c10162007.spcon)
	e2:SetOperation(c10162007.spop)
	c:RegisterEffect(e2)
	--fusion material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_FUSION_MATERIAL)
	e3:SetCondition(c10162007.fuscon)
	e3:SetOperation(c10162007.fusop)
	c:RegisterEffect(e3)
	--win
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c10162007.winop)
	c:RegisterEffect(e4)
	local e9=e4:Clone()
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e9)
	--Negate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(c10162007.disop)
	c:RegisterEffect(e6)
	--destroy replace
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EFFECT_DESTROY_REPLACE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTarget(c10162007.retg)
	e7:SetOperation(c10162007.reop)
	c:RegisterEffect(e7)
	--cannot attack
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_ATTACK)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(c10162007.antarget)
	c:RegisterEffect(e8)  
end
function c10162007.antarget(e,c)
	return c~=e:GetHandler()
end
function c10162007.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT) end
	if Duel.SelectYesNo(tp,aux.Stringid(10162007,1)) then
		return true
	else return false end
end
function c10162007.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c10162007.disop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not tg or not tg:IsContains(e:GetHandler()) or not Duel.IsChainDisablable(ev) then return false end
	local rc=re:GetHandler()
	local dc=Duel.TossDice(tp,1)
	if Duel.SelectYesNo(tp,aux.Stringid(10162007,2)) then
	   Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
		Duel.NegateEffect(ev)
		if rc:IsRelateToEffect(re) then
			Duel.Destroy(rc,REASON_EFFECT)
		end
	end
end
function c10162007.winop(e,tp,eg,ep,ev,re,r,rp)
	--local WIN_REASON_FUCKING_DRAGON=0x56
	if Duel.GetLP(tp)==1 then
		--Duel.Win(tp,WIN_REASON_FUCKING_DRAGON)
	   Duel.Hint(HINT_CARD,0,10162007)
	   Duel.SetLP(1-tp,0)
	end
end
function c10162007.mfilter1(c,mg)
	return c:IsSetCard(0x9333) and c:IsType(TYPE_XYZ) and mg:IsExists(c10162007.mfilter2,1,c) and mg:IsExists(c10162007.mfilter3,1,c)
end
function c10162007.mfilter2(c)
	return c:IsSetCard(0x9333) and c:IsType(TYPE_SYNCHRO)
end
function c10162007.mfilter3(c)
	return c:IsSetCard(0x9333) and c:IsType(TYPE_FUSION)
end
function c10162007.fuscon(e,mg,gc)
	if mg==nil then return false end
	if gc then return false end
	return mg:IsExists(c10162007.mfilter1,1,nil,mg)
end
function c10162007.fusop(e,tp,eg,ep,ev,re,r,rp,gc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g1=eg:FilterSelect(tp,c10162007.mfilter1,1,1,nil,eg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=eg:FilterSelect(tp,c10162007.mfilter2,1,1,g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g3=eg:FilterSelect(tp,c10162007.mfilter3,1,1,g1:GetFirst())
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.SetFusionMaterial(g1)
end
function c10162007.spcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<-2 then return false end
	local g1=Duel.GetMatchingGroup(c10162007.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,TYPE_XYZ)
	local g2=Duel.GetMatchingGroup(c10162007.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,TYPE_SYNCHRO)
	local g3=Duel.GetMatchingGroup(c10162007.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,TYPE_FUSION)
	if g1:GetCount()==0 or g2:GetCount()==0 or g3:GetCount()==0 then return false end
	if ft>0 then return true end
	local f1=g1:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)>0 and 1 or 0
	local f2=g2:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)>0 and 1 or 0
	local f3=g3:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)>0 and 1 or 0
	if ft==-2 then return f1+f2+f3==3
	elseif ft==-1 then return f1+f2+f3>=2
	else return f1+f2+f3>=1 end
end
function c10162007.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g1=Duel.GetMatchingGroup(c10162007.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,TYPE_XYZ)
	local g2=Duel.GetMatchingGroup(c10162007.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,TYPE_SYNCHRO)
	local g3=Duel.GetMatchingGroup(c10162007.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,TYPE_FUSION)
	g1:Merge(g2)
	g1:Merge(g3)
	local g=Group.CreateGroup()
	local tc=nil
	for i=1,3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		if ft<=0 then
			tc=g1:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE):GetFirst()
		else
			tc=g1:Select(tp,1,1,nil):GetFirst()
		end
		g:AddCard(tc)
		 if tc:IsType(TYPE_XYZ) and not tc:IsType(TYPE_SYNCHRO) and not tc:IsType(TYPE_FUSION) then
		  g1:Remove(Card.IsType,nil,TYPE_XYZ)
		 elseif tc:IsType(TYPE_SYNCHRO) and not tc:IsType(TYPE_XYZ) and not tc:IsType(TYPE_FUSION) then 
		  g1:Remove(Card.IsType,nil,TYPE_SYNCHRO)
		 elseif tc:IsType(TYPE_FUSION) and not tc:IsType(TYPE_XYZ) and not tc:IsType(TYPE_SYNCHRO) then 
		  g1:Remove(Card.IsType,nil,TYPE_FUSION)
		 else 
		  g1:RemoveCard(tc)
		 end
		ft=ft+1
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10162007.spfilter(c,type)
	return c:IsFaceup() and c:IsType(type) and c:IsAbleToRemoveAsCost() and c:IsSetCard(0x9333)
end